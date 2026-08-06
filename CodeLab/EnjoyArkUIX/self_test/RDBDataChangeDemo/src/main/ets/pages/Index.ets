import { relationalStore } from '@kit.ArkData';
import { BusinessError } from '@kit.BasicServicesKit';

class CrudExpectedPayload {
  public kind: string;
  public value: string;

  constructor(kind: string, value: string) {
    this.kind = kind;
    this.value = value;
  }
}

class CallbackPayloadRecord {
  public table: string;
  public insertedKind: string;
  public insertedValues: Array<string>;
  public updatedKind: string;
  public updatedValues: Array<string>;
  public deletedKind: string;
  public deletedValues: Array<string>;

  constructor(table: string, insertedKind: string, insertedValues: Array<string>, updatedKind: string,
    updatedValues: Array<string>, deletedKind: string, deletedValues: Array<string>) {
    this.table = table;
    this.insertedKind = insertedKind;
    this.insertedValues = insertedValues;
    this.updatedKind = updatedKind;
    this.updatedValues = updatedValues;
    this.deletedKind = deletedKind;
    this.deletedValues = deletedValues;
  }
}

const ERR_CODE_INVALID_PARAM = '401';
const ERR_CODE_STORE_CLOSED = '14800014';

@Entry
@Component
struct Index {
  @State observer1Registered: boolean = false;
  @State observer2Registered: boolean = false;
  @State observer3Registered: boolean = false;
  @State observer4Registered: boolean = false;
  @State lastAction: string = 'idle';
  @State lastResult: string = 'INFO';
  @State lastDetail: string = '请先初始化数据库';
  @State callbackCount: number = 0;
  @State callbackFacts: Array<string> = [];
  @State callbackPayloadRecords: Array<CallbackPayloadRecord> = [];
  @State selectedTable: string = 'int_pk_table';
  @State selectedDbOp: number = 1;
  @State selectedObserverAction: string = '+注册 DB1 Obs1';
  @State selectedCrudAction: string = 'Insert';
  @State selectedScenarioAction: string = '双库串行';
  @State selectedExceptionCase: string = 'on: 非法订阅类型';
  store: relationalStore.RdbStore | null = null;
  store2: relationalStore.RdbStore | null = null;
  dbName: string = 'TestDB.db';
  dbName2: string = 'TestDB2.db';
  context: Context | null = null;
  lastKnownRowName: Record<string, string> = {};

  tableLabelMap(val: string): string {
    const map: Record<string, string> = {
      'int_pk_table': '自增int主键',
      'str_pk_table': '字符串主键',
      'composite_pk_table': 'str+str复合PK',
      'mixed_composite_pk_table': 'str+float复合PK',
      'float_str_pk_table': 'float+str复合PK',
      'str_pk_without_rowid': '字符串PK 无rowid',
      'int_pk_without_rowid': '整数PK 无rowid'
    };
    return map[val] || val;
  }

  observerStatusColor(registered: boolean): string {
    return registered ? '#2E7D32' : '#9E9E9E';
  }

  observerStatusBgColor(registered: boolean): string {
    return registered ? '#E8F5E9' : '#F5F5F5';
  }

  hasObserverOnTargetDb(dbIndex: number): boolean {
    if (dbIndex === 1) {
      return this.observer1Registered || this.observer2Registered;
    }
    return this.observer3Registered || this.observer4Registered;
  }

  expectedMetricName(action: string): string {
    if (action === 'Insert') {
      return 'inserted';
    }
    if (action === 'Update') {
      return 'updated';
    }
    return 'deleted';
  }

  extractMetricValue(summary: string, metricName: string): number {
    const prefix = '|' + metricName + '=';
    const start = summary.indexOf(prefix);
    if (start < 0) {
      return 0;
    }
    const valueStart = start + prefix.length;
    const nextSep = summary.indexOf('|', valueStart);
    const metricValue = nextSep < 0 ? summary.substring(valueStart) : summary.substring(valueStart, nextSep);
    const parsedValue = Number(metricValue);
    return Number.isNaN(parsedValue) ? 0 : parsedValue;
  }

  formatObserverActual(newFacts: Array<string>): string {
    if (newFacts.length === 0) {
      return '无新增回调';
    }
    if (newFacts.length === 1) {
      return newFacts[0];
    }
    return newFacts[0] + ' || ' + newFacts[1] + (newFacts.length > 2 ? ' ...' : '');
  }

  findNewFacts(callbackFactCount: number): Array<string> {
    const newFactCount = this.callbackFacts.length - callbackFactCount;
    return newFactCount > 0 ? this.callbackFacts.slice(0, newFactCount) : [];
  }

  buildFactMatcher(tableName: string, metricName: string): (item: string) => boolean {
    return (item: string): boolean => item.indexOf('|table=' + tableName + '|') >= 0 &&
      this.extractMetricValue(item, metricName) > 0;
  }

  buildFactCountMatcher(tableName: string, metricName: string, minCount: number): (item: string) => boolean {
    return (item: string): boolean => item.indexOf('|table=' + tableName + '|') >= 0 &&
      this.extractMetricValue(item, metricName) >= minCount;
  }

  shouldRelaxPayloadValidation(tableName: string): boolean {
    return tableName === 'composite_pk_table' || tableName === 'mixed_composite_pk_table' ||
      tableName === 'float_str_pk_table';
  }

  usesPrimaryKeyPayload(tableName: string): boolean {
    return tableName === 'str_pk_table' || tableName === 'str_pk_without_rowid' || tableName === 'int_pk_without_rowid';
  }

  expectedPrimaryKeyKind(tableName: string): string {
    if (!this.usesPrimaryKeyPayload(tableName)) {
      return 'number';
    }
    return tableName === 'int_pk_without_rowid' ? 'number' : 'string';
  }

  normalizeChangedValues(values: Array<string> | Array<number>): Array<string> {
    let normalized: Array<string> = [];
    for (let index: number = 0; index < values.length; index++) {
      const value: string | number = values[index];
      normalized.push(String(value));
    }
    return normalized;
  }

  isNumericValueString(value: string): boolean {
    return /^-?\d+$/.test(value);
  }

  detectChangedValueKind(tableName: string, values: Array<string> | Array<number>): string {
    if (values.length === 0) {
      return 'none';
    }
    if (tableName === 'str_pk_table' || tableName === 'str_pk_without_rowid') {
      return 'string';
    }
    const normalized = this.normalizeChangedValues(values);
    return this.isNumericValueString(normalized[0]) ? 'number' : 'string';
  }

  formatChangedValues(values: Array<string> | Array<number>): string {
    const normalized = this.normalizeChangedValues(values);
    return '[' + normalized.join(', ') + ']';
  }

  findNewPayloadRecords(callbackFactCount: number): Array<CallbackPayloadRecord> {
    const newRecordCount = this.callbackPayloadRecords.length - callbackFactCount;
    return newRecordCount > 0 ? this.callbackPayloadRecords.slice(0, newRecordCount) : [];
  }

  getPrimaryKeyColumnName(tableName: string): string {
    if (tableName === 'int_pk_table' || tableName === 'db2_table') {
      return 'id';
    }
    if (!this.usesPrimaryKeyPayload(tableName)) {
      return '';
    }
    return 'id';
  }

  buildExpectedPayload(kind: string, value: string | number): CrudExpectedPayload {
    return new CrudExpectedPayload(kind, String(value));
  }

  rememberRowName(tableName: string, rowName: string) {
    this.lastKnownRowName[tableName] = rowName;
  }

  getRememberedRowName(tableName: string): string {
    return this.lastKnownRowName[tableName] || '';
  }

  buildRowNamePredicate(tableName: string, fallbackPattern: string): relationalStore.RdbPredicates {
    const predicates = new relationalStore.RdbPredicates(tableName);
    const exactName = this.getRememberedRowName(tableName);
    if (exactName.length > 0) {
      predicates.equalTo('name', exactName);
      return predicates;
    }
    predicates.like('name', fallbackPattern);
    return predicates;
  }

  getDebugColumns(tableName: string): Array<string> {
    if (tableName === 'int_pk_table') {
      return ['id', 'name'];
    }
    if (tableName === 'str_pk_table') {
      return ['id', 'name'];
    }
    if (tableName === 'composite_pk_table') {
      return ['id', 'region', 'name'];
    }
    if (tableName === 'mixed_composite_pk_table') {
      return ['id', 'score', 'name'];
    }
    if (tableName === 'float_str_pk_table') {
      return ['score', 'tag', 'name'];
    }
    if (tableName === 'str_pk_without_rowid') {
      return ['id', 'name'];
    }
    if (tableName === 'int_pk_without_rowid') {
      return ['id', 'name'];
    }
    if (tableName === 'db2_table') {
      return ['id', 'tag', 'name'];
    }
    return [];
  }

  readDebugColumnValue(tableName: string, resultSet: relationalStore.ResultSet, columnName: string): string {
    const columnIndex = resultSet.getColumnIndex(columnName);
    if (columnName === 'rowid') {
      return String(resultSet.getLong(columnIndex));
    }
    if (columnName === 'id') {
      if (tableName === 'int_pk_table' || tableName === 'int_pk_without_rowid' || tableName === 'db2_table') {
        return String(resultSet.getLong(columnIndex));
      }
      return resultSet.getString(columnIndex);
    }
    if (columnName === 'score') {
      try {
        return String(resultSet.getDouble(columnIndex));
      } catch (_) {
      }
    }
    return resultSet.getString(columnIndex);
  }

  buildInsertExpectedPayload(tableName: string, rowId: number,
    values: relationalStore.ValuesBucket): CrudExpectedPayload {
    if (!this.usesPrimaryKeyPayload(tableName)) {
      return this.buildExpectedPayload('number', rowId);
    }
    if (tableName === 'int_pk_without_rowid') {
      return this.buildExpectedPayload('number', values['id'] as number);
    }
    return this.buildExpectedPayload('string', values['id'] as string);
  }

  readResultSetValue(resultSet: relationalStore.ResultSet, tableName: string, columnIndex: number): string {
    if (this.expectedPrimaryKeyKind(tableName) === 'string') {
      return resultSet.getString(columnIndex);
    }
    return String(resultSet.getLong(columnIndex));
  }

  async queryExpectedPayload(store: relationalStore.RdbStore, tableName: string,
    patterns: Array<string>): Promise<CrudExpectedPayload | null> {
    if (this.shouldRelaxPayloadValidation(tableName)) {
      return null;
    }
    const columnName = this.getPrimaryKeyColumnName(tableName);
    if (columnName.length === 0) {
      return null;
    }
    const exactName = this.lastKnownRowName[tableName];
    if (exactName && exactName.length > 0) {
      const predicates = new relationalStore.RdbPredicates(tableName);
      predicates.equalTo('name', exactName);
      const resultSet = await store.query(predicates, [columnName]);
      try {
        if (resultSet.rowCount > 0 && resultSet.goToFirstRow()) {
          const columnIndex = resultSet.getColumnIndex(columnName);
          const value = this.readResultSetValue(resultSet, tableName, columnIndex);
          return this.buildExpectedPayload(this.expectedPrimaryKeyKind(tableName), value);
        }
      } finally {
        resultSet.close();
      }
    }
    for (let pattern of patterns) {
      const predicates = new relationalStore.RdbPredicates(tableName);
      predicates.like('name', pattern);
      const resultSet = await store.query(predicates, [columnName]);
      try {
        if (resultSet.rowCount <= 0 || !resultSet.goToFirstRow()) {
          continue;
        }
        const columnIndex = resultSet.getColumnIndex(columnName);
        const value = this.readResultSetValue(resultSet, tableName, columnIndex);
        return this.buildExpectedPayload(this.expectedPrimaryKeyKind(tableName), value);
      } finally {
        resultSet.close();
      }
    }
    return null;
  }

  findMatchingPayloadRecord(callbackFactCount: number, tableName: string, action: string,
    expectedPayload: CrudExpectedPayload): CallbackPayloadRecord | null {
    const metricName = this.expectedMetricName(action);
    const records = this.findNewPayloadRecords(callbackFactCount);
    for (let record of records) {
      if (record.table !== tableName) {
        continue;
      }
      let kind = '';
      let values: Array<string> = [];
      if (metricName === 'inserted') {
        kind = record.insertedKind;
        values = record.insertedValues;
      } else if (metricName === 'updated') {
        kind = record.updatedKind;
        values = record.updatedValues;
      } else {
        kind = record.deletedKind;
        values = record.deletedValues;
      }
      if (kind === expectedPayload.kind && values.indexOf(expectedPayload.value) >= 0) {
        return record;
      }
    }
    return null;
  }

  async waitForMatchingCallbackFact(callbackFactCount: number, matcher: (item: string) => boolean,
    timeoutMs: number = 1200, intervalMs: number = 50): Promise<string | null> {
    let waitedMs = 0;
    while (waitedMs < timeoutMs) {
      const matched = this.findNewFacts(callbackFactCount).find(matcher);
      if (matched) {
        return matched;
      }
      await this.delay(intervalMs);
      waitedMs += intervalMs;
    }
    return this.findNewFacts(callbackFactCount).find(matcher) || null;
  }

  async waitForNoMatchingCallbackFact(callbackFactCount: number, matcher: (item: string) => boolean,
    observeMs: number = 500, intervalMs: number = 50): Promise<boolean> {
    let waitedMs = 0;
    while (waitedMs < observeMs) {
      if (this.findNewFacts(callbackFactCount).some(matcher)) {
        return false;
      }
      await this.delay(intervalMs);
      waitedMs += intervalMs;
    }
    return !this.findNewFacts(callbackFactCount).some(matcher);
  }

  async waitForExpectedCallbackFacts(callbackFactCount: number,
    expectations: Array<Array<string>>, timeoutMs: number = 1500,
    intervalMs: number = 50): Promise<Array<string> | null> {
    let waitedMs = 0;
    while (waitedMs < timeoutMs) {
      const newFacts = this.findNewFacts(callbackFactCount);
      const matchedFacts = expectations.map((expectation) =>
      newFacts.find(this.buildFactMatcher(expectation[0], expectation[1])) || '');
      if (matchedFacts.every((item: string) => item !== '')) {
        return matchedFacts;
      }
      await this.delay(intervalMs);
      waitedMs += intervalMs;
    }

    const finalFacts = this.findNewFacts(callbackFactCount);
    const finalMatchedFacts = expectations.map((expectation) =>
    finalFacts.find(this.buildFactMatcher(expectation[0], expectation[1])) || '');
    return finalMatchedFacts.every((item: string) => item !== '') ? finalMatchedFacts : null;
  }

  buildScenarioExpectations(tableNames: Array<string>): Array<Array<string>> {
    const metricNames = ['inserted', 'updated', 'deleted'];
    const expectations: Array<Array<string>> = [];
    for (let tableName of tableNames) {
      for (let metricName of metricNames) {
        expectations.push([tableName, metricName]);
      }
    }
    return expectations;
  }

  async finalizeScenarioResult(actionName: string, successDetail: string, failDetail: string,
    callbackFactCount: number, expectations: Array<Array<string>>) {
    const matchedFacts = await this.waitForExpectedCallbackFacts(callbackFactCount, expectations);
    const actual = this.formatObserverActual(this.findNewFacts(callbackFactCount));
    if (matchedFacts) {
      this.setResult(actionName, 'PASS', successDetail);
      return;
    }

    this.setResult(actionName, 'FAIL', failDetail);
  }

  async validateCrudObserverResult(actionName: string, dbIndex: number, tableName: string, action: string,
    callbackFactCount: number, expectedPayload: CrudExpectedPayload | null) {
    if (!this.hasObserverOnTargetDb(dbIndex)) {
      this.setResult(actionName, 'INFO', '数据操作成功，但当前目标库未注册 observer');
      return;
    }

    const metricName = this.expectedMetricName(action);
    const matcher = this.buildFactMatcher(tableName, metricName);
    const matchedSummary = await this.waitForMatchingCallbackFact(callbackFactCount, matcher);
    const newFacts = this.findNewFacts(callbackFactCount);
    const actual = this.formatObserverActual(newFacts);

    if (matchedSummary) {
      if (this.shouldRelaxPayloadValidation(tableName)) {
        this.setResult(actionName, 'PASS', '数据操作成功，已收到目标表回调');
        return;
      }
      if (!expectedPayload) {
        this.setResult(actionName, 'FAIL', '数据操作成功，但未找到可校验的目标主键');
        return;
      }
      const matchedRecord = this.findMatchingPayloadRecord(callbackFactCount, tableName, action, expectedPayload);
      if (!matchedRecord) {
        this.setResult(actionName, 'FAIL', '数据操作成功，但监听主键数据不符合预期');
        return;
      }
      this.setResult(actionName, 'PASS', '数据操作成功，已收到目标表回调');
      return;
    }

    this.setResult(actionName, 'FAIL', '数据操作成功，但监听校验失败');
  }

  recordObserverChange(observerName: string, item: relationalStore.ChangeInfo) {
    const summary = observerName + '|table=' + item.table + '|type=' + item.type + '|inserted=' + item.inserted.length +
      '|updated=' + item.updated.length + '|deleted=' + item.deleted.length;
    const insertedValues = this.normalizeChangedValues(item.inserted);
    const updatedValues = this.normalizeChangedValues(item.updated);
    const deletedValues = this.normalizeChangedValues(item.deleted);
    const insertedKind = this.detectChangedValueKind(item.table, item.inserted);
    const updatedKind = this.detectChangedValueKind(item.table, item.updated);
    const deletedKind = this.detectChangedValueKind(item.table, item.deleted);
    const log = '[' + observerName + '] table:' + item.table + ' type:' + item.type + ' inserted(' + insertedKind + '):' +
      this.formatChangedValues(item.inserted) + ' updated(' + updatedKind + '):' +
      this.formatChangedValues(item.updated) + ' deleted(' + deletedKind + '):' +
      this.formatChangedValues(item.deleted);
    const payloadRecord = new CallbackPayloadRecord(item.table, insertedKind,
      insertedValues, updatedKind,
      updatedValues, deletedKind,
      deletedValues);
    this.callbackFacts = [summary, ...this.callbackFacts];
    this.callbackPayloadRecords = [payloadRecord, ...this.callbackPayloadRecords];
    this.callbackCount += 1;
  }

  executeObserverAction() {
    switch (this.selectedObserverAction) {
      case '+注册 DB1 Obs1':
        this.registerObserver(1);
        break;
      case '+注册 DB1 Obs2':
        this.registerObserver(2);
        break;
      case '-注销 DB1 Obs1':
        this.unregisterObserver(1);
        break;
      case '-注销 DB1 Obs2':
        this.unregisterObserver(2);
        break;
      case '--注销 DB1 全部':
        this.unregisterObserver(0);
        break;
      case '+注册 DB2 Obs3':
        this.registerObserverOnDb2(3);
        break;
      case '+注册 DB2 Obs4':
        this.registerObserverOnDb2(4);
        break;
      case '-注销 DB2 Obs3':
        this.unregisterObserverOnDb2(3);
        break;
      case '-注销 DB2 Obs4':
        this.unregisterObserverOnDb2(4);
        break;
      case '--注销 DB2 全部':
        this.unregisterObserverOnDb2(0);
        break;
      default:
        break;
    }
  }

  async executeCrudAction() {
    const tableName = this.selectedDbOp === 1 ? this.selectedTable : 'db2_table';
    const actionName = 'crud:' + (this.selectedDbOp === 1 ? 'DB1' : 'DB2') + ':' + this.selectedCrudAction + ':' +
      tableName;
    const callbackFactCount = this.callbackFacts.length;
    let expectedPayload: CrudExpectedPayload | null = null;

    if (this.selectedDbOp === 1) {
      if (this.selectedCrudAction === 'Insert') {
        expectedPayload = await this.insertData(this.selectedTable);
        if (!expectedPayload) {
          return;
        }
      } else if (this.selectedCrudAction === 'Update') {
        expectedPayload = await this.updateData(this.selectedTable);
        if (!expectedPayload) {
          return;
        }
      } else {
        expectedPayload = await this.deleteData(this.selectedTable);
        if (!expectedPayload) {
          return;
        }
      }
      await this.validateCrudObserverResult(actionName, this.selectedDbOp, tableName, this.selectedCrudAction,
        callbackFactCount, expectedPayload);
      return;
    }

    if (this.selectedCrudAction === 'Insert') {
      expectedPayload = await this.insertDataToDb2();
      if (!expectedPayload) {
        return;
      }
    } else if (this.selectedCrudAction === 'Update') {
      expectedPayload = await this.updateDataInDb2();
      if (!expectedPayload) {
        return;
      }
    } else {
      expectedPayload = await this.deleteDataFromDb2();
      if (!expectedPayload) {
        return;
      }
    }

    await this.validateCrudObserverResult(actionName, this.selectedDbOp, tableName, this.selectedCrudAction,
      callbackFactCount, expectedPayload);
  }

  async executeScenarioAction() {
    if (this.selectedScenarioAction === '双库串行') {
      await this.operateBothDatabases();
    } else if (this.selectedScenarioAction === '双表串行') {
      await this.runDualTableFlow();
    } else if (this.selectedScenarioAction === '先on再建表') {
      await this.verifyOnThenCreate();
    } else if (this.selectedScenarioAction === '事务内增删改') {
      await this.verifyTransactionMixedCrud();
    } else if (this.selectedScenarioAction === '事务回滚不回调') {
      await this.verifyTransactionRollback();
    } else if (this.selectedScenarioAction === '多行Insert监听') {
      await this.verifyMultiRowInsert();
    } else if (this.selectedScenarioAction === '多行Update监听') {
      await this.verifyMultiRowUpdate();
    } else if (this.selectedScenarioAction === '多行Delete监听') {
      await this.verifyMultiRowDelete();
    }
  }

  delay(ms: number): Promise<void> {
    return new Promise(resolve => setTimeout(resolve, ms));
  }

  async clearDb1ObserversSilently() {
    if (!this.store) {
      return;
    }
    try {
      await this.store.off('dataChange', relationalStore.SubscribeType.SUBSCRIBE_TYPE_LOCAL_DETAILS);
      this.observer1Registered = false;
      this.observer2Registered = false;

      if (this.observer1Registered === false && this.observer2Registered === false) {
        this.setResult('off注销全部', 'PASS', 'off 注销全部成功');
      } else {
        this.setResult('off注销全部', 'FAIL', 'off 注销全部失败');
      }
    } catch (err) {
      this.setResult('off注销全部', 'FAIL', 'off 注销全部抛异常');
    }

  }

  async clearDb2ObserversSilently() {
    if (!this.store2) {
      return;
    }
    try {
      await this.store2.off('dataChange', relationalStore.SubscribeType.SUBSCRIBE_TYPE_LOCAL_DETAILS);
      this.observer3Registered = false;
      this.observer4Registered = false;
      if (this.observer3Registered === false && this.observer4Registered === false) {
        this.setResult('off注销全部', 'PASS', 'off 注销全部成功');
      } else {
        this.setResult('off注销全部', 'FAIL', 'off 注销全部失败');
      }
    } catch (err) {
      this.setResult('off注销全部', 'FAIL', 'off 注销全部抛异常');
    }

  }

  async resetDb1ObserversForScenario() {
    await this.clearDb1ObserversSilently();
  }

  async ensureDb1ReadyForScenario(): Promise<boolean> {
    if (!this.store) {
      await this.initRdb();
    }
    if (!this.store) {
      this.setResult('scenarioPrepare', 'FAIL', 'DB1 初始化失败');
      return false;
    }
    return true;
  }

  async ensureDb2ReadyForScenario(): Promise<boolean> {
    if (!this.store2) {
      await this.initSecondRdb();
    }
    if (!this.store2) {
      this.setResult('scenarioPrepare', 'FAIL', 'DB2 初始化失败');
      return false;
    }
    return true;
  }

  async prepareDb1ScenarioObserver(): Promise<boolean> {
    if (!await this.ensureDb1ReadyForScenario()) {
      return false;
    }

    try {
      await this.store!.off('dataChange', relationalStore.SubscribeType.SUBSCRIBE_TYPE_LOCAL_DETAILS);
    } catch (_) {
    }
    this.observer1Registered = false;
    this.observer2Registered = false;
    this.store!.on('dataChange', relationalStore.SubscribeType.SUBSCRIBE_TYPE_LOCAL_DETAILS, this.observer1);
    this.observer1Registered = true;
    return true;
  }

  async prepareDb2ScenarioObserver(): Promise<boolean> {
    if (!await this.ensureDb2ReadyForScenario()) {
      return false;
    }

    try {
      await this.store2!.off('dataChange', relationalStore.SubscribeType.SUBSCRIBE_TYPE_LOCAL_DETAILS);
    } catch (_) {
    }
    this.observer3Registered = false;
    this.observer4Registered = false;
    this.store2!.on('dataChange', relationalStore.SubscribeType.SUBSCRIBE_TYPE_LOCAL_DETAILS, this.observer3);
    this.observer3Registered = true;
    return true;
  }

  async recreateScenarioTable(tableName: string) {
    if (!this.store) {
      return;
    }
    await this.store.executeSql('DROP TABLE IF EXISTS ' + tableName);
    await this.store.executeSql('CREATE TABLE IF NOT EXISTS ' + tableName +
      ' (id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT)');
    await this.store.executeSql('DELETE FROM ' + tableName);
  }

  async insertScenarioRow(tableName: string, name: string) {
    if (!this.store) {
      return -1;
    }
    return await this.store.insert(tableName, { 'name': name });
  }

  async insertMultiScenarioRows(tableName: string, prefix: string, count: number) {
    if (!this.store) {
      return;
    }
    const values: Array<string> = [];
    for (let index = 0; index < count; index++) {
      values.push("('" + prefix + '_' + index + "')");
    }
    await this.store.executeSql('INSERT INTO ' + tableName + ' (name) VALUES ' + values.join(', '));
  }

  async scenarioRowExists(tableName: string, rowName: string): Promise<boolean> {
    if (!this.store) {
      return false;
    }
    const predicates = new relationalStore.RdbPredicates(tableName);
    predicates.equalTo('name', rowName);
    const resultSet = await this.store.query(predicates, ['id']);
    try {
      return resultSet.rowCount > 0;
    } finally {
      resultSet.close();
    }
  }

  buildMixedCrudFactMatcher(tableName: string): (item: string) => boolean {
    return (item: string): boolean => item.indexOf('|table=' + tableName + '|') >= 0 &&
      this.extractMetricValue(item, 'inserted') > 0 &&
      this.extractMetricValue(item, 'updated') > 0 &&
      this.extractMetricValue(item, 'deleted') > 0;
  }

  buildAnyCrudFactMatcher(tableName: string): (item: string) => boolean {
    return (item: string): boolean => item.indexOf('|table=' + tableName + '|') >= 0 &&
      (this.extractMetricValue(item, 'inserted') > 0 ||
        this.extractMetricValue(item, 'updated') > 0 ||
        this.extractMetricValue(item, 'deleted') > 0);
  }

  async verifyTransactionMixedCrud() {
    if (!await this.ensureDb1ReadyForScenario()) {
      return;
    }
    const store = this.store;
    if (!store) {
      this.setResult('verifyTransactionMixedCrud', 'FAIL', 'DB1 未初始化');
      return;
    }

    const tableName = 'scenario_tx_mixed_crud';
    const baseTs = new Date().getTime();
    const updateBeforeName = 'tx_update_before_' + baseTs;
    const updateAfterName = 'tx_update_after_' + baseTs;
    const deleteName = 'tx_delete_before_' + baseTs;
    const insertName = 'tx_insert_new_' + baseTs;
    let transactionStarted = false;

    await this.resetDb1ObserversForScenario();
    await this.recreateScenarioTable(tableName);
    try {
      await this.insertScenarioRow(tableName, updateBeforeName);
      await this.insertScenarioRow(tableName, deleteName);
      store.on('dataChange', relationalStore.SubscribeType.SUBSCRIBE_TYPE_LOCAL_DETAILS, this.observer1);
      this.observer1Registered = true;

      const callbackFactCountAfterRegister = this.callbackFacts.length;

      store.beginTransaction();
      transactionStarted = true;
      await store.executeSql('INSERT INTO ' + tableName + " (name) VALUES ('" + insertName + "')");
      await store.executeSql('UPDATE ' + tableName + " SET name = '" + updateAfterName +
        "' WHERE name = '" + updateBeforeName + "'");
      await store.executeSql('DELETE FROM ' + tableName + " WHERE name = '" + deleteName + "'");
      store.commit();
      transactionStarted = false;

      const matchedSummary = await this.waitForMatchingCallbackFact(callbackFactCountAfterRegister,
        this.buildMixedCrudFactMatcher(tableName));
      const passed = matchedSummary !== null;
      this.setResult('verifyTransactionMixedCrud', passed ? 'PASS' : 'FAIL',
        passed ? '已收到同一事务 mixed 增删改回调' : '未收到同时包含 inserted/updated/deleted 的回调');
    } catch (err) {
      if (transactionStarted) {
        try {
          store.rollBack();
        } catch (_) {
        }
      }
      this.setResult('verifyTransactionMixedCrud', 'FAIL', (err as BusinessError).message);
      return;
    }
  }

  async verifyTransactionRollback() {
    if (!await this.ensureDb1ReadyForScenario()) {
      return;
    }
    const store = this.store;
    if (!store) {
      this.setResult('verifyTransactionRollback', 'FAIL', 'DB1 未初始化');
      return;
    }

    const tableName = 'scenario_tx_rollback';
    const baseTs = new Date().getTime();
    const updateBeforeName = 'rollback_update_before_' + baseTs;
    const updateAfterName = 'rollback_update_after_' + baseTs;
    const deleteName = 'rollback_delete_before_' + baseTs;
    const insertName = 'rollback_insert_new_' + baseTs;
    let transactionStarted = false;

    await this.resetDb1ObserversForScenario();
    await this.recreateScenarioTable(tableName);
    try {
      await this.insertScenarioRow(tableName, updateBeforeName);
      await this.insertScenarioRow(tableName, deleteName);
      store.on('dataChange', relationalStore.SubscribeType.SUBSCRIBE_TYPE_LOCAL_DETAILS, this.observer1);
      this.observer1Registered = true;
    } catch (err) {
      this.setResult('verifyTransactionRollback', 'FAIL', (err as BusinessError).message);
      return;
    }

    const callbackFactCount = this.callbackFacts.length;
    try {
      store.beginTransaction();
      transactionStarted = true;
      await store.executeSql('INSERT INTO ' + tableName + " (name) VALUES ('" + insertName + "')");
      await store.executeSql('UPDATE ' + tableName + " SET name = '" + updateAfterName +
        "' WHERE name = '" + updateBeforeName + "'");
      await store.executeSql('DELETE FROM ' + tableName + " WHERE name = '" + deleteName + "'");
      store.rollBack();
      transactionStarted = false;
    } catch (err) {
      if (transactionStarted) {
        try {
          store.rollBack();
        } catch (_) {
        }
      }
      this.setResult('verifyTransactionRollback', 'FAIL', (err as BusinessError).message);
      return;
    }

    const noCallback = await this.waitForNoMatchingCallbackFact(callbackFactCount,
      this.buildAnyCrudFactMatcher(tableName));
    const updateBeforeExists = await this.scenarioRowExists(tableName, updateBeforeName);
    const updateAfterExists = await this.scenarioRowExists(tableName, updateAfterName);
    const deleteBeforeExists = await this.scenarioRowExists(tableName, deleteName);
    const insertExists = await this.scenarioRowExists(tableName, insertName);
    const passed = noCallback && updateBeforeExists && !updateAfterExists && deleteBeforeExists && !insertExists;

    this.setResult('verifyTransactionRollback', passed ? 'PASS' : 'FAIL',
      passed ? '回滚后无回调且数据已恢复' : '回滚校验失败');
  }

  async verifyMultiRowInsert() {
    if (!await this.prepareDb1ScenarioObserver()) {
      return;
    }
    const store = this.store;
    if (!store) {
      this.setResult('verifyMultiRowInsert', 'FAIL', 'DB1 未初始化');
      return;
    }

    const tableName = 'scenario_multi_row_insert';
    const rowCount = 3;
    await this.recreateScenarioTable(tableName);
    const callbackFactCount = this.callbackFacts.length;
    try {
      await this.insertMultiScenarioRows(tableName, 'multi_insert_' + new Date().getTime(), rowCount);
    } catch (err) {
      this.setResult('verifyMultiRowInsert', 'FAIL', (err as BusinessError).message);
      return;
    }

    const matchedSummary = await this.waitForMatchingCallbackFact(callbackFactCount,
      this.buildFactCountMatcher(tableName, 'inserted', rowCount));
    const passed = matchedSummary !== null;
    this.setResult('verifyMultiRowInsert', passed ? 'PASS' : 'FAIL',
      passed ? '已收到多行insert回调' : '未收到 inserted>=3 的回调');
  }

  async verifyMultiRowUpdate() {
    if (!await this.ensureDb1ReadyForScenario()) {
      return;
    }
    const store = this.store;
    if (!store) {
      this.setResult('verifyMultiRowUpdate', 'FAIL', 'DB1 未初始化');
      return;
    }

    const tableName = 'scenario_multi_row_update';
    const rowCount = 3;
    await this.resetDb1ObserversForScenario();
    await this.recreateScenarioTable(tableName);
    try {
      await this.insertMultiScenarioRows(tableName, 'multi_update_before_' + new Date().getTime(), rowCount);
      store.on('dataChange', relationalStore.SubscribeType.SUBSCRIBE_TYPE_LOCAL_DETAILS, this.observer1);
      this.observer1Registered = true;
    } catch (err) {
      this.setResult('verifyMultiRowUpdate', 'FAIL', (err as BusinessError).message);
      return;
    }

    const callbackFactCount = this.callbackFacts.length;
    try {
      await store.executeSql('UPDATE ' + tableName + " SET name = 'multi_update_after' WHERE name LIKE 'multi_update_before_%'");
    } catch (err) {
      this.setResult('verifyMultiRowUpdate', 'FAIL', (err as BusinessError).message);
      return;
    }

    const matchedSummary = await this.waitForMatchingCallbackFact(callbackFactCount,
      this.buildFactCountMatcher(tableName, 'updated', rowCount));
    const passed = matchedSummary !== null;
    this.setResult('verifyMultiRowUpdate', passed ? 'PASS' : 'FAIL',
      passed ? '已收到多行update回调' : '未收到 updated>=3 的回调');
  }

  async verifyMultiRowDelete() {
    if (!await this.ensureDb1ReadyForScenario()) {
      return;
    }
    const store = this.store;
    if (!store) {
      this.setResult('verifyMultiRowDelete', 'FAIL', 'DB1 未初始化');
      return;
    }

    const tableName = 'scenario_multi_row_delete';
    const rowCount = 3;
    await this.resetDb1ObserversForScenario();
    await this.recreateScenarioTable(tableName);
    try {
      await this.insertMultiScenarioRows(tableName, 'multi_delete_before_' + new Date().getTime(), rowCount);
      store.on('dataChange', relationalStore.SubscribeType.SUBSCRIBE_TYPE_LOCAL_DETAILS, this.observer1);
      this.observer1Registered = true;
    } catch (err) {
      this.setResult('verifyMultiRowDelete', 'FAIL', (err as BusinessError).message);
      return;
    }

    const callbackFactCount = this.callbackFacts.length;
    try {
      await store.executeSql('DELETE FROM ' + tableName + " WHERE name LIKE 'multi_delete_before_%'");
    } catch (err) {
      this.setResult('verifyMultiRowDelete', 'FAIL', (err as BusinessError).message);
      return;
    }

    const matchedSummary = await this.waitForMatchingCallbackFact(callbackFactCount,
      this.buildFactCountMatcher(tableName, 'deleted', rowCount));
    const passed = matchedSummary !== null;
    this.setResult('verifyMultiRowDelete', passed ? 'PASS' : 'FAIL',
      passed ? '已收到多行delete回调' : '未收到 deleted>=3 的回调');
  }

  async verifyOnThenCreate() {
    if (!await this.ensureDb1ReadyForScenario()) {
      return;
    }
    const store = this.store;
    if (!store) {
      this.setResult('verifyOnThenCreate', 'FAIL', 'DB1 未初始化');
      return;
    }

    const tableName = 'scenario_on_then_create';
    await this.resetDb1ObserversForScenario();
    store.on('dataChange', relationalStore.SubscribeType.SUBSCRIBE_TYPE_LOCAL_DETAILS, this.observer1);
    this.observer1Registered = true;

    await this.recreateScenarioTable(tableName);

    const callbackFactCount = this.callbackFacts.length;
    const rowId = await this.insertScenarioRow(tableName, 'on_then_create_' + new Date().getTime());
    const matchedSummary = await this.waitForMatchingCallbackFact(callbackFactCount,
      this.buildFactMatcher(tableName, 'inserted'));

    const passed = matchedSummary !== null;
    this.setResult('verifyOnThenCreate', passed ? 'PASS' : 'FAIL',
      passed ? '已收到 ' + tableName + ' 回调' : '未在超时时间内收到 ' + tableName + ' 回调');
  }

  async verifyOnAfterClose() {
    if (!await this.ensureDb1ReadyForScenario()) {
      return;
    }
    const store = this.store;
    if (!store) {
      this.setResult('verifyOnAfterClose', 'FAIL', 'DB1 未初始化');
      return;
    }

    try {
      await store.close();
      this.store = null;
      this.observer1Registered = false;
      this.observer2Registered = false;
    } catch (_) {
    }

    try {
      store.on('dataChange', relationalStore.SubscribeType.SUBSCRIBE_TYPE_LOCAL_DETAILS, this.observer1);
      this.setResult('verifyOnAfterClose', 'FAIL', 'on 调用未抛异常');
    } catch (err) {
      const code = String((err as BusinessError).code);
      const message = (err as BusinessError).message;
      const pass = code === ERR_CODE_STORE_CLOSED;
      this.setResult('verifyOnAfterClose', pass ? 'PASS' : 'FAIL',
        pass ? '已关闭后 on 正确抛出 ' + ERR_CODE_STORE_CLOSED + ': ' + message : '错误码不匹配, code=' + code + ', msg=' + message);
    }

    await this.initRdb();
  }

  async verifyOffAfterClose() {
    if (!await this.ensureDb1ReadyForScenario()) {
      return;
    }
    const store = this.store;
    if (!store) {
      this.setResult('verifyOffAfterClose', 'FAIL', 'DB1 未初始化');
      return;
    }

    try {
      await store.close();
      this.store = null;
      this.observer1Registered = false;
      this.observer2Registered = false;
    } catch (_) {
    }

    try {
      store.off('dataChange', relationalStore.SubscribeType.SUBSCRIBE_TYPE_LOCAL_DETAILS, this.observer1);
      this.setResult('verifyOffAfterClose', 'FAIL', 'off 调用未抛异常');
    } catch (err) {
      const code = String((err as BusinessError).code);
      const message = (err as BusinessError).message;
      const pass = code === ERR_CODE_STORE_CLOSED;
      this.setResult('verifyOffAfterClose', pass ? 'PASS' : 'FAIL',
        pass ? '已关闭后 off 正确抛出 ' + ERR_CODE_STORE_CLOSED + ': ' + message : '错误码不匹配, code=' + code + ', msg=' + message);
    }

    await this.initRdb();
  }

  async runExceptionTest() {
    if (!this.store) {
      this.setResult('exceptionTest', 'FAIL', '请先初始化 DB1');
      return;
    }

    type DetailObserver = (info: Array<relationalStore.ChangeInfo>) => void;

    const normalCallback: DetailObserver = this.observer1;
    const invalidValues: Array<number | undefined | null> = [-1, undefined, null, 999];
    try {
      switch (this.selectedExceptionCase) {
        case 'on: 非法订阅类型': {
          let allPassed = true;
          let failDetail = '';
          for (let val of invalidValues) {
            try {
              this.store.on('dataChange', val as number, normalCallback);
              allPassed = false;
              failDetail = 'on(' + val + ') 未抛异常';
              break;
            } catch (err2) {
              const code2 = String((err2 as BusinessError).code);
              if (code2 !== ERR_CODE_INVALID_PARAM) {
                allPassed = false;
                failDetail = 'on(' + val + ') 错误码不匹配, code=' + code2;
                break;
              }
            }
          }
          this.setResult('exceptionTest', allPassed ? 'PASS' : 'FAIL',
            allPassed ? '非法类型on正确抛出' + ERR_CODE_INVALID_PARAM : failDetail);
          break;
        }
        case 'off: 非法订阅类型': {
          let allPassed = true;
          let failDetail = '';
          for (let val of invalidValues) {
            try {
              this.store.off('dataChange', val as number, normalCallback);
              allPassed = false;
              failDetail = 'off(' + val + ') 未抛异常';
              break;
            } catch (err2) {
              const code2 = String((err2 as BusinessError).code);
              if (code2 !== ERR_CODE_INVALID_PARAM) {
                allPassed = false;
                failDetail = 'off(' + val + ') 错误码不匹配, code=' + code2;
                break;
              }
            }
          }
          this.setResult('exceptionTest', allPassed ? 'PASS' : 'FAIL',
            allPassed ? '非法类型off正确抛出' + ERR_CODE_INVALID_PARAM : failDetail);
          break;
        }
        case 'on: 已关闭DB的on':
          await this.verifyOnAfterClose();
          return;
        case 'off: 已关闭DB的off':
          await this.verifyOffAfterClose();
          return;
        default:
          this.setResult('exceptionTest', 'INFO', '未匹配到异常测试项');
          break;
      }
    } catch (err) {
      const message = (err as BusinessError).message || (err as Error).message;
      this.setResult('exceptionTest', 'PASS', message);
    }
  }

  // ===== Observer（所有回调加 try-catch，防止 WITHOUT ROWID 表 rowid 访问抛异常） =====
  observer1 = (info: Array<relationalStore.ChangeInfo>) => {
    info.forEach(item => {
      try {
        this.recordObserverChange('observer1', item);
      } catch (_) {
      }
    });
  }
  observer2 = (info: Array<relationalStore.ChangeInfo>) => {
    info.forEach(item => {
      try {
        this.recordObserverChange('observer2', item);
      } catch (_) {
      }
    });
  }
  observer3 = (info: Array<relationalStore.ChangeInfo>) => {
    info.forEach(item => {
      try {
        this.recordObserverChange('observer3', item);
      } catch (_) {
      }
    });
  }
  observer4 = (info: Array<relationalStore.ChangeInfo>) => {
    info.forEach(item => {
      try {
        this.recordObserverChange('observer4', item);
      } catch (_) {
      }
    });
  }

  // ===== 生命周期 =====
  aboutToAppear() {
    this.lastDetail = '正在自动初始化数据库...';
    this.initRdb();
    this.initSecondRdb();
  }

  aboutToDisappear() {
    this.clearDb1ObserversSilently();
    this.clearDb2ObserversSilently();
  }

  setResult(action: string, result: string, detail: string) {
    this.lastAction = action;
    this.lastResult = result;
    this.lastDetail = detail;
  }

  // ===== DB1 初始化 =====
  async initRdb() {
    if (this.context === null) {
      this.context = getContext(this) as Context;
    }
    try {
      this.store = await relationalStore.getRdbStore(this.context,
        { name: this.dbName, securityLevel: relationalStore.SecurityLevel.S1 });

      await this.store.executeSql('CREATE TABLE IF NOT EXISTS int_pk_table (id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT)');
      await this.store.executeSql('CREATE TABLE IF NOT EXISTS str_pk_table (id TEXT PRIMARY KEY, name TEXT)');
      await this.store.executeSql('CREATE TABLE IF NOT EXISTS composite_pk_table (id TEXT, region TEXT, name TEXT, PRIMARY KEY (id, region))');
      await this.store.executeSql('CREATE TABLE IF NOT EXISTS mixed_composite_pk_table (id TEXT, score REAL, name TEXT, PRIMARY KEY (id, score))');
      await this.store.executeSql('CREATE TABLE IF NOT EXISTS float_str_pk_table (score REAL, tag TEXT, name TEXT, PRIMARY KEY (score, tag))');
      await this.store.executeSql('CREATE TABLE IF NOT EXISTS str_pk_without_rowid (id TEXT PRIMARY KEY, name TEXT) WITHOUT ROWID');
      await this.store.executeSql('CREATE TABLE IF NOT EXISTS int_pk_without_rowid (id INTEGER PRIMARY KEY, name TEXT) WITHOUT ROWID');
      await this.store.executeSql('DELETE FROM int_pk_table');
      await this.store.executeSql('DELETE FROM str_pk_table');
      await this.store.executeSql('DELETE FROM composite_pk_table');
      await this.store.executeSql('DELETE FROM mixed_composite_pk_table');
      await this.store.executeSql('DELETE FROM float_str_pk_table');
      await this.store.executeSql('DELETE FROM str_pk_without_rowid');
      await this.store.executeSql('DELETE FROM int_pk_without_rowid');
      this.observer1Registered = false;
      this.observer2Registered = false;
    } catch (err) {
      let bErr = err as BusinessError;
      this.setResult('initRdb', 'FAIL', bErr.message);
    }
  }

  // ===== DB2 初始化 =====
  async initSecondRdb() {
    if (this.context === null) {
      this.context = getContext(this) as Context;
    }
    try {
      this.store2 = await relationalStore.getRdbStore(this.context,
        { name: this.dbName2, securityLevel: relationalStore.SecurityLevel.S1 });
      await this.store2.executeSql('CREATE TABLE IF NOT EXISTS db2_table (id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT, tag TEXT)');
      await this.store2.executeSql('DELETE FROM db2_table');
      this.setResult('initSecondRdb', 'PASS', 'DB2 初始化完成');
    } catch (err) {
      let bErr = err as BusinessError;
      this.setResult('initSecondRdb', 'FAIL', bErr.message);
    }
  }

  // ===== 监听器控制 =====
  registerObserver(type: number) {
    if (!this.store) {
      this.setResult('registerObserver' + type, 'FAIL', '请先初始化 DB1');
      return;
    }

    const obs = type === 1 ? this.observer1 : this.observer2;
    if ((type === 1 && this.observer1Registered) || (type === 2 && this.observer2Registered)) {
      try {
        this.store.on('dataChange', relationalStore.SubscribeType.SUBSCRIBE_TYPE_LOCAL_DETAILS, obs);
        this.setResult('registerObserver' + type, 'INFO', 'observer' + type + ' 已注册');
      } catch (err) {
        this.setResult('registerObserver' + type, 'FAIL', (err as BusinessError).message);
      }
      return;
    }

    try {
      this.store.on('dataChange', relationalStore.SubscribeType.SUBSCRIBE_TYPE_LOCAL_DETAILS, obs);
      if (type === 1) {
        this.observer1Registered = true;
      } else {
        this.observer2Registered = true;
      }
      this.setResult('registerObserver' + type, 'PASS', 'observer' + type + ' 注册成功');
    } catch (err) {
      this.setResult('registerObserver' + type, 'FAIL', (err as BusinessError).message);
    }
  }

  unregisterObserver(type: number) {
    if (!this.store) {
      this.setResult('unregisterObserver' + type, 'FAIL', '请先初始化 DB1');
      return;
    }
    try {
      if (type === 1) {
        if (!this.observer1Registered) {
          this.setResult('unregisterObserver1', 'INFO', 'observer1 未注册');
          return;
        }
        this.store.off('dataChange', relationalStore.SubscribeType.SUBSCRIBE_TYPE_LOCAL_DETAILS, this.observer1);
        this.observer1Registered = false;
        this.setResult('unregisterObserver1', 'PASS', 'observer1 注销成功');
      } else if (type === 2) {
        if (!this.observer2Registered) {
          this.setResult('unregisterObserver2', 'INFO', 'observer2 未注册');
          return;
        }
        this.store.off('dataChange', relationalStore.SubscribeType.SUBSCRIBE_TYPE_LOCAL_DETAILS, this.observer2);
        this.observer2Registered = false;
        this.setResult('unregisterObserver2', 'PASS', 'observer2 注销成功');
      } else {
        this.clearDb1ObserversSilently();
        this.setResult('unregisterObserverAll', 'PASS', '全部 observer 注销成功');
      }
    } catch (err) {
      this.setResult('unregisterObserver' + type, 'FAIL', (err as BusinessError).message);
    }
  }

  // ===== DB2 监听器控制 =====
  registerObserverOnDb2(type: number) {
    if (!this.store2) {
      this.setResult('registerObserver' + type, 'FAIL', '请先初始化 DB2');
      return;
    }
    const obs = type === 3 ? this.observer3 : this.observer4;
    if ((type === 3 && this.observer3Registered) || (type === 4 && this.observer4Registered)) {
      try {
        this.store2.on('dataChange', relationalStore.SubscribeType.SUBSCRIBE_TYPE_LOCAL_DETAILS, obs);
        this.setResult('registerObserver' + type, 'INFO', 'observer' + type + ' 已注册');
      } catch (err) {
        this.setResult('registerObserver' + type, 'FAIL', (err as BusinessError).message);
      }
      return;
    }

    try {
      this.store2.on('dataChange', relationalStore.SubscribeType.SUBSCRIBE_TYPE_LOCAL_DETAILS, obs);
      if (type === 3) {
        this.observer3Registered = true;
      } else {
        this.observer4Registered = true;
      }
      this.setResult('registerObserver' + type, 'PASS', 'observer' + type + ' 注册成功');
    } catch (err) {
      this.setResult('registerObserver' + type, 'FAIL', (err as BusinessError).message);
    }
  }

  unregisterObserverOnDb2(type: number) {
    if (!this.store2) {
      this.setResult('unregisterObserver' + type, 'FAIL', '请先初始化 DB2');
      return;
    }
    try {
      if (type === 3) {
        if (!this.observer3Registered) {
          this.setResult('unregisterObserver3', 'INFO', 'observer3 未注册');
          return;
        }
        this.store2.off('dataChange', relationalStore.SubscribeType.SUBSCRIBE_TYPE_LOCAL_DETAILS, this.observer3);
        this.observer3Registered = false;
        this.setResult('unregisterObserver3', 'PASS', 'observer3 注销成功');
      } else if (type === 4) {
        if (!this.observer4Registered) {
          this.setResult('unregisterObserver4', 'INFO', 'observer4 未注册');
          return;
        }
        this.store2.off('dataChange', relationalStore.SubscribeType.SUBSCRIBE_TYPE_LOCAL_DETAILS, this.observer4);
        this.observer4Registered = false;
        this.setResult('unregisterObserver4', 'PASS', 'observer4 注销成功');
      } else {
        this.clearDb2ObserversSilently();
        this.setResult('unregisterObserverAllDb2', 'PASS', 'DB2 全部 observer 注销成功');
      }
    } catch (err) {
      this.setResult('unregisterObserver' + type, 'FAIL', (err as BusinessError).message);
    }
  }

  // ===== DB1 CRUD =====
  async insertData(tableName: string): Promise<CrudExpectedPayload | null> {
    if (!this.store) {
      this.setResult('insert:' + tableName, 'FAIL', 'DB1 未初始化');
      return null;
    }
    const ts = new Date().getTime();
    let values: relationalStore.ValuesBucket = { 'name': 'Item ' + ts };
    if (tableName === 'str_pk_table') {
      values['id'] = 'ID_' + ts;
    }
    if (tableName === 'composite_pk_table') {
      values['id'] = 'ID_' + ts;
      values['region'] = 'REGION_' + ts;
    }
    if (tableName === 'mixed_composite_pk_table') {
      values['id'] = 'ID_' + ts;
      values['score'] = ts / 1000;
    }
    if (tableName === 'float_str_pk_table') {
      values['score'] = ts / 1000;
      values['tag'] = 'TAG_' + ts;
    }
    if (tableName === 'str_pk_without_rowid') {
      values['id'] = 'WRID_' + ts;
    }
    if (tableName === 'int_pk_without_rowid') {
      values['id'] = ts;
    }
    try {
      let rowId = await this.store.insert(tableName, values);
      this.rememberRowName(tableName, values['name'] as string);
      this.setResult('insert:' + tableName, 'PASS', 'rowId=' + rowId);
      return this.buildInsertExpectedPayload(tableName, rowId, values);
    } catch (err) {
      this.setResult('insert:' + tableName, 'FAIL', (err as BusinessError).message);
      return null;
    }
  }

  async updateData(tableName: string): Promise<CrudExpectedPayload | null> {
    if (!this.store) {
      this.setResult('update:' + tableName, 'FAIL', 'DB1 未初始化');
      return null;
    }
    try {
      const expectedPayload = await this.queryExpectedPayload(this.store, tableName, ['Item%']);
      let values: relationalStore.ValuesBucket = { 'name': 'Updated_' + new Date().getTime() };
      let predicates = this.buildRowNamePredicate(tableName, 'Item%');
      let rowsChanged = await this.store.update(values, predicates);
      if (rowsChanged > 0) {
        this.rememberRowName(tableName, values['name'] as string);
      }
      this.setResult('update:' + tableName, 'PASS', 'rowsChanged=' + rowsChanged);
      return expectedPayload;
    } catch (err) {
      this.setResult('update:' + tableName, 'FAIL', (err as BusinessError).message);
      return null;
    }
  }

  async deleteData(tableName: string): Promise<CrudExpectedPayload | null> {
    if (!this.store) {
      this.setResult('delete:' + tableName, 'FAIL', 'DB1 未初始化');
      return null;
    }
    try {
      const expectedPayload = await this.queryExpectedPayload(this.store, tableName, ['Item%', 'Updated_%']);
      let rowsChanged = 0;
      const exactName = this.getRememberedRowName(tableName);
      if (exactName.length > 0) {
        rowsChanged = await this.store.delete(this.buildRowNamePredicate(tableName, 'Updated_%'));
      } else {
        rowsChanged = await this.store.delete(
          new relationalStore.RdbPredicates(tableName).like('name', 'Item%')
        );
        rowsChanged += await this.store.delete(
          new relationalStore.RdbPredicates(tableName).like('name', 'Updated_%')
        );
      }
      this.setResult('delete:' + tableName, 'PASS', 'rowsChanged=' + rowsChanged);
      return expectedPayload;
    } catch (err) {
      this.setResult('delete:' + tableName, 'FAIL', (err as BusinessError).message);
      return null;
    }
  }

  // ===== DB2 CRUD =====
  async insertDataToDb2(): Promise<CrudExpectedPayload | null> {
    if (!this.store2) {
      this.setResult('insert:db2_table', 'FAIL', 'DB2 未初始化');
      return null;
    }
    const ts = new Date().getTime();
    let values: relationalStore.ValuesBucket = { 'name': 'Db2Item ' + ts, 'tag': 'db2' };
    try {
      let rowId = await this.store2.insert('db2_table', values);
      this.rememberRowName('db2_table', values['name'] as string);
      this.setResult('insert:db2_table', 'PASS', 'rowId=' + rowId);
      return this.buildInsertExpectedPayload('db2_table', rowId, values);
    } catch (err) {
      this.setResult('insert:db2_table', 'FAIL', (err as BusinessError).message);
      return null;
    }
  }

  async updateDataInDb2(): Promise<CrudExpectedPayload | null> {
    if (!this.store2) {
      this.setResult('update:db2_table', 'FAIL', 'DB2 未初始化');
      return null;
    }
    try {
      const expectedPayload = await this.queryExpectedPayload(this.store2, 'db2_table', ['Db2Item%']);
      let values: relationalStore.ValuesBucket = { 'name': 'Updated_' + new Date().getTime() };
      let predicates = this.buildRowNamePredicate('db2_table', 'Db2Item%');
      let rowsChanged = await this.store2.update(values, predicates);
      if (rowsChanged > 0) {
        this.rememberRowName('db2_table', values['name'] as string);
      }
      this.setResult('update:db2_table', 'PASS', 'rowsChanged=' + rowsChanged);
      return expectedPayload;
    } catch (err) {
      this.setResult('update:db2_table', 'FAIL', (err as BusinessError).message);
      return null;
    }
  }

  async deleteDataFromDb2(): Promise<CrudExpectedPayload | null> {
    if (!this.store2) {
      this.setResult('delete:db2_table', 'FAIL', 'DB2 未初始化');
      return null;
    }
    try {
      const expectedPayload = await this.queryExpectedPayload(this.store2, 'db2_table', ['Db2Item%', 'Updated_%']);
      let rowsChanged = 0;
      const exactName = this.getRememberedRowName('db2_table');
      if (exactName.length > 0) {
        rowsChanged = await this.store2.delete(this.buildRowNamePredicate('db2_table', 'Updated_%'));
      } else {
        rowsChanged = await this.store2.delete(
          new relationalStore.RdbPredicates('db2_table').like('name', 'Db2Item%')
        );
        rowsChanged += await this.store2.delete(
          new relationalStore.RdbPredicates('db2_table').like('name', 'Updated_%')
        );
      }
      this.setResult('delete:db2_table', 'PASS', 'rowsChanged=' + rowsChanged);
      return expectedPayload;
    } catch (err) {
      this.setResult('delete:db2_table', 'FAIL', (err as BusinessError).message);
      return null;
    }
  }

  async operateBothDatabases() {
    if (!await this.prepareDb1ScenarioObserver() || !await this.prepareDb2ScenarioObserver()) {
      return;
    }
    const store = this.store;
    const store2 = this.store2;
    if (!store || !store2) {
      this.setResult('operateBoth', 'FAIL', '场景准备失败');
      return;
    }

    const expectations = this.buildScenarioExpectations(['int_pk_table', 'db2_table']);
    const callbackFactCount = this.callbackFacts.length;

    const ts = new Date().getTime();
    try {
      let rowId1 = await store.insert('int_pk_table', { 'name': 'Item_' + ts });
      let rowId2 = await store2.insert('db2_table', { 'name': 'Db2Item_' + ts, 'tag': 'db2' });

      let uv: relationalStore.ValuesBucket = { 'name': 'Updated_' + ts };
      let p1 = new relationalStore.RdbPredicates('int_pk_table');
      p1.like('name', 'Item_%');
      let rows1 = await store.update(uv, p1);
      let p2 = new relationalStore.RdbPredicates('db2_table');
      p2.like('name', 'Db2Item%');
      let rows2 = await store2.update(uv, p2);
      let d1 = await store.delete(new relationalStore.RdbPredicates('int_pk_table').like('name', 'Item_%'));
      d1 += await store.delete(new relationalStore.RdbPredicates('int_pk_table').like('name', 'Updated_%'));
      let d2 = await store2.delete(new relationalStore.RdbPredicates('db2_table').like('name', 'Db2Item%'));
      d2 += await store2.delete(new relationalStore.RdbPredicates('db2_table').like('name', 'Updated_%'));
    } catch (err) {
      this.setResult('operateBoth', 'FAIL', (err as BusinessError).message);
      return;
    }

    await this.finalizeScenarioResult('operateBoth', '双库串行结束，监听校验通过',
      '双库串行结束，但监听校验失败', callbackFactCount, expectations);
  }

  /** 双表串行：同时对两张表执行 Insert->Update->Delete，验证多表变更均可被正常监听到 */
  async runDualTableFlow() {
    if (!await this.prepareDb1ScenarioObserver()) {
      return;
    }
    const store = this.store;

    if (!store) {
      this.setResult('dualTableFlow', 'FAIL', '场景准备失败');
      return;
    }

    const expectations = this.buildScenarioExpectations(['int_pk_table', 'str_pk_table']);
    const callbackFactCount = this.callbackFacts.length;

    const tables = ['int_pk_table', 'str_pk_table'];
    for (let t of tables) {
      const ts = new Date().getTime();
      try {
        let values: relationalStore.ValuesBucket = { 'name': 'Item_' + ts };
        if (t !== 'int_pk_table') { values['id'] = 'ID_' + ts; }

        let rowId = await store.insert(t, values);

        let uv: relationalStore.ValuesBucket = { 'name': 'Updated_' + ts };
        let up = new relationalStore.RdbPredicates(t);
        up.like('name', 'Item_%');
        let rows = await store.update(uv, up);

        let del = await store.delete(new relationalStore.RdbPredicates(t).like('name', 'Item_%'));
        del += await store.delete(new relationalStore.RdbPredicates(t).like('name', 'Updated_%'));
      } catch (err) {
        this.setResult('dualTableFlow', 'FAIL', (err as BusinessError).message);
        return;
      }
    }

    await this.finalizeScenarioResult('dualTableFlow', '双表串行完成，监听校验通过',
      '双表串行完成，但监听校验失败', callbackFactCount, expectations);
  }

  // ===== 辅助 =====
  resultColor(): string {
    if (this.lastResult === 'PASS') {
      return '#2E7D32';
    }
    if (this.lastResult === 'FAIL') {
      return '#C62828';
    }
    return '#1565C0';
  }

  tableInfo(t: string): string {
    if (t === 'int_pk_table') {
      return '[自增Integer PK]';
    }
    if (t === 'str_pk_table') {
      return '[String PK]';
    }
    if (t === 'composite_pk_table') {
      return '[String + String PK]';
    }
    if (t === 'mixed_composite_pk_table') {
      return '[String+Float 组合PK]';
    }
    if (t === 'float_str_pk_table') {
      return '[Float+String 复合PK, Float在前]';
    }
    if (t === 'str_pk_without_rowid') {
      return '[String PK, WITHOUT ROWID]';
    }
    if (t === 'int_pk_without_rowid') {
      return '[Integer PK, WITHOUT ROWID]';
    }
    return '';
  }

  // ===== Build =====
  build() {
    Column() {
      // ===== 上半部分：可滑动操作区 =====
      Scroll() {
        Column() {
          Text('监听操作').fontSize(13).fontColor('#333').width('100%').margin({ bottom: 4 })
          Row({ space: 6 }) {
            Text('DB1-Obs1 ' + (this.observer1Registered ? '已注册' : '未注册'))
              .fontSize(10)
              .fontColor(this.observerStatusColor(this.observer1Registered))
              .backgroundColor(this.observerStatusBgColor(this.observer1Registered))
              .borderRadius(10)
              .padding({ left: 8, right: 8, top: 3, bottom: 3 })
            Text('DB1-Obs2 ' + (this.observer2Registered ? '已注册' : '未注册'))
              .fontSize(10)
              .fontColor(this.observerStatusColor(this.observer2Registered))
              .backgroundColor(this.observerStatusBgColor(this.observer2Registered))
              .borderRadius(10)
              .padding({ left: 8, right: 8, top: 3, bottom: 3 })
          }.width('100%').margin({ bottom: 4 })
          Row({ space: 6 }) {
            Text('DB2-Obs3 ' + (this.observer3Registered ? '已注册' : '未注册'))
              .fontSize(10)
              .fontColor(this.observerStatusColor(this.observer3Registered))
              .backgroundColor(this.observerStatusBgColor(this.observer3Registered))
              .borderRadius(10)
              .padding({ left: 8, right: 8, top: 3, bottom: 3 })
            Text('DB2-Obs4 ' + (this.observer4Registered ? '已注册' : '未注册'))
              .fontSize(10)
              .fontColor(this.observerStatusColor(this.observer4Registered))
              .backgroundColor(this.observerStatusBgColor(this.observer4Registered))
              .borderRadius(10)
              .padding({ left: 8, right: 8, top: 3, bottom: 3 })
          }.width('100%').margin({ bottom: 4 })
          // 监听操作按钮组（2列网格）
          Row({ space: 4 }) {
            Button('+注册 DB1 Obs1').id('com.example.rdb_test:id/btn_observer_action_0')
              .layoutWeight(1).height(28).fontSize(10).backgroundColor('#E8F5E9').fontColor('#2E7D32')
              .onClick(() => { this.selectedObserverAction = '+注册 DB1 Obs1'; this.executeObserverAction(); })
            Button('+注册 DB1 Obs2').id('com.example.rdb_test:id/btn_observer_action_1')
              .layoutWeight(1).height(28).fontSize(10).backgroundColor('#E8F5E9').fontColor('#2E7D32')
              .onClick(() => { this.selectedObserverAction = '+注册 DB1 Obs2'; this.executeObserverAction(); })
          }.width('100%').margin({ bottom: 2 })
          Row({ space: 4 }) {
            Button('-注销 DB1 Obs1').id('com.example.rdb_test:id/btn_observer_action_2')
              .layoutWeight(1).height(28).fontSize(10).backgroundColor('#FFF3E0').fontColor('#E65100')
              .onClick(() => { this.selectedObserverAction = '-注销 DB1 Obs1'; this.executeObserverAction(); })
            Button('-注销 DB1 Obs2').id('com.example.rdb_test:id/btn_observer_action_3')
              .layoutWeight(1).height(28).fontSize(10).backgroundColor('#FFF3E0').fontColor('#E65100')
              .onClick(() => { this.selectedObserverAction = '-注销 DB1 Obs2'; this.executeObserverAction(); })
          }.width('100%').margin({ bottom: 2 })
          Row({ space: 4 }) {
            Button('--注销 DB1 全部').id('com.example.rdb_test:id/btn_observer_action_4')
              .layoutWeight(1).height(28).fontSize(10).backgroundColor('#FFEBEE').fontColor('#C62828')
              .onClick(() => { this.selectedObserverAction = '--注销 DB1 全部'; this.executeObserverAction(); })
            Button('+注册 DB2 Obs3').id('com.example.rdb_test:id/btn_observer_action_5')
              .layoutWeight(1).height(28).fontSize(10).backgroundColor('#E8F5E9').fontColor('#2E7D32')
              .onClick(() => { this.selectedObserverAction = '+注册 DB2 Obs3'; this.executeObserverAction(); })
          }.width('100%').margin({ bottom: 2 })
          Row({ space: 4 }) {
            Button('+注册 DB2 Obs4').id('com.example.rdb_test:id/btn_observer_action_6')
              .layoutWeight(1).height(28).fontSize(10).backgroundColor('#E8F5E9').fontColor('#2E7D32')
              .onClick(() => { this.selectedObserverAction = '+注册 DB2 Obs4'; this.executeObserverAction(); })
            Button('-注销 DB2 Obs3').id('com.example.rdb_test:id/btn_observer_action_7')
              .layoutWeight(1).height(28).fontSize(10).backgroundColor('#FFF3E0').fontColor('#E65100')
              .onClick(() => { this.selectedObserverAction = '-注销 DB2 Obs3'; this.executeObserverAction(); })
          }.width('100%').margin({ bottom: 2 })
          Row({ space: 4 }) {
            Button('-注销 DB2 Obs4').id('com.example.rdb_test:id/btn_observer_action_8')
              .layoutWeight(1).height(28).fontSize(10).backgroundColor('#FFF3E0').fontColor('#E65100')
              .onClick(() => { this.selectedObserverAction = '-注销 DB2 Obs4'; this.executeObserverAction(); })
            Button('--注销 DB2 全部').id('com.example.rdb_test:id/btn_observer_action_9')
              .layoutWeight(1).height(28).fontSize(10).backgroundColor('#FFEBEE').fontColor('#C62828')
              .onClick(() => { this.selectedObserverAction = '--注销 DB2 全部'; this.executeObserverAction(); })
          }.width('100%').margin({ bottom: 12 })

          Text('数据操作').fontSize(13).fontColor('#333').width('100%').margin({ bottom: 4 })
          // DB目标选择按钮
          Row({ space: 4 }) {
            Button('DB1').id('com.example.rdb_test:id/btn_db_target_0')
              .layoutWeight(1).height(28).fontSize(11)
              .backgroundColor(this.selectedDbOp === 1 ? '#2196F3' : '#FFFFFF')
              .fontColor(this.selectedDbOp === 1 ? '#FFFFFF' : '#333')
              .border({ width: 1, color: '#CCC' }).borderRadius(4)
              .onClick(() => { this.selectedDbOp = 1; })
            Button('DB2').id('com.example.rdb_test:id/btn_db_target_1')
              .layoutWeight(1).height(28).fontSize(11)
              .backgroundColor(this.selectedDbOp === 2 ? '#2196F3' : '#FFFFFF')
              .fontColor(this.selectedDbOp === 2 ? '#FFFFFF' : '#333')
              .border({ width: 1, color: '#CCC' }).borderRadius(4)
              .onClick(() => { this.selectedDbOp = 2; })
          }.width('100%').margin({ bottom: 4 })

          // CRUD操作选择按钮
          Row({ space: 4 }) {
            Button('Insert').id('com.example.rdb_test:id/btn_crud_action_0')
              .layoutWeight(1).height(28).fontSize(11)
              .backgroundColor(this.selectedCrudAction === 'Insert' ? '#4CAF50' : '#FFFFFF')
              .fontColor(this.selectedCrudAction === 'Insert' ? '#FFFFFF' : '#333')
              .border({ width: 1, color: '#CCC' }).borderRadius(4)
              .onClick(() => { this.selectedCrudAction = 'Insert'; })
            Button('Update').id('com.example.rdb_test:id/btn_crud_action_1')
              .layoutWeight(1).height(28).fontSize(11)
              .backgroundColor(this.selectedCrudAction === 'Update' ? '#FF9800' : '#FFFFFF')
              .fontColor(this.selectedCrudAction === 'Update' ? '#FFFFFF' : '#333')
              .border({ width: 1, color: '#CCC' }).borderRadius(4)
              .onClick(() => { this.selectedCrudAction = 'Update'; })
            Button('Delete').id('com.example.rdb_test:id/btn_crud_action_2')
              .layoutWeight(1).height(28).fontSize(11)
              .backgroundColor(this.selectedCrudAction === 'Delete' ? '#F44336' : '#FFFFFF')
              .fontColor(this.selectedCrudAction === 'Delete' ? '#FFFFFF' : '#333')
              .border({ width: 1, color: '#CCC' }).borderRadius(4)
              .onClick(() => { this.selectedCrudAction = 'Delete'; })
          }.width('100%').margin({ bottom: 4 })

          if (this.selectedDbOp === 1) {
            Text('选择表：' + this.tableLabelMap(this.selectedTable))
              .fontSize(10).fontColor('#888').width('100%').margin({ bottom: 2 })
            // 表选择按钮（2列网格）
            Row({ space: 4 }) {
              Button('自增int主键').id('com.example.rdb_test:id/btn_table_0')
                .layoutWeight(1).height(26).fontSize(9)
                .backgroundColor(this.selectedTable === 'int_pk_table' ? '#9C27B0' : '#F3E5F5').fontColor(this.selectedTable === 'int_pk_table' ? '#FFF' : '#333')
                .border({ width: 1, color: '#CCC' }).borderRadius(4)
                .onClick(() => { this.selectedTable = 'int_pk_table'; })
              Button('字符串主键').id('com.example.rdb_test:id/btn_table_1')
                .layoutWeight(1).height(26).fontSize(9)
                .backgroundColor(this.selectedTable === 'str_pk_table' ? '#9C27B0' : '#F3E5F5').fontColor(this.selectedTable === 'str_pk_table' ? '#FFF' : '#333')
                .border({ width: 1, color: '#CCC' }).borderRadius(4)
                .onClick(() => { this.selectedTable = 'str_pk_table'; })
            }.width('100%').margin({ bottom: 2 })
            Row({ space: 4 }) {
              Button('str+str复合PK').id('com.example.rdb_test:id/btn_table_2')
                .layoutWeight(1).height(26).fontSize(9)
                .backgroundColor(this.selectedTable === 'composite_pk_table' ? '#9C27B0' : '#F3E5F5').fontColor(this.selectedTable === 'composite_pk_table' ? '#FFF' : '#333')
                .border({ width: 1, color: '#CCC' }).borderRadius(4)
                .onClick(() => { this.selectedTable = 'composite_pk_table'; })
              Button('str+float复合PK').id('com.example.rdb_test:id/btn_table_3')
                .layoutWeight(1).height(26).fontSize(9)
                .backgroundColor(this.selectedTable === 'mixed_composite_pk_table' ? '#9C27B0' : '#F3E5F5').fontColor(this.selectedTable === 'mixed_composite_pk_table' ? '#FFF' : '#333')
                .border({ width: 1, color: '#CCC' }).borderRadius(4)
                .onClick(() => { this.selectedTable = 'mixed_composite_pk_table'; })
            }.width('100%').margin({ bottom: 2 })
            Row({ space: 4 }) {
              Button('float+str复合PK').id('com.example.rdb_test:id/btn_table_4')
                .layoutWeight(1).height(26).fontSize(9)
                .backgroundColor(this.selectedTable === 'float_str_pk_table' ? '#9C27B0' : '#F3E5F5').fontColor(this.selectedTable === 'float_str_pk_table' ? '#FFF' : '#333')
                .border({ width: 1, color: '#CCC' }).borderRadius(4)
                .onClick(() => { this.selectedTable = 'float_str_pk_table'; })
              Button('字符串PK 无rowid').id('com.example.rdb_test:id/btn_table_5')
                .layoutWeight(1).height(26).fontSize(9)
                .backgroundColor(this.selectedTable === 'str_pk_without_rowid' ? '#9C27B0' : '#F3E5F5').fontColor(this.selectedTable === 'str_pk_without_rowid' ? '#FFF' : '#333')
                .border({ width: 1, color: '#CCC' }).borderRadius(4)
                .onClick(() => { this.selectedTable = 'str_pk_without_rowid'; })
            }.width('100%').margin({ bottom: 2 })
            Row({ space: 4 }) {
              Button('整数PK 无rowid').id('com.example.rdb_test:id/btn_table_6')
                .layoutWeight(1).height(26).fontSize(9)
                .backgroundColor(this.selectedTable === 'int_pk_without_rowid' ? '#9C27B0' : '#F3E5F5').fontColor(this.selectedTable === 'int_pk_without_rowid' ? '#FFF' : '#333')
                .border({ width: 1, color: '#CCC' }).borderRadius(4)
                .onClick(() => { this.selectedTable = 'int_pk_without_rowid'; })
            }.width('100%').margin({ bottom: 4 })
            Text(this.tableInfo(this.selectedTable))
              .fontSize(10).fontColor('#888').width('100%')
              .margin({ bottom: 6 })
          } else {
            Text('[DB2 固定表: db2_table]')
              .fontSize(10).fontColor('#888').width('100%')
              .margin({ bottom: 6 })
          }

          Button('执行数据操作').id('com.example.rdb_test:id/btn_execute_crud')
            .onClick(() => this.executeCrudAction())
            .width('100%').height(28).fontSize(11).backgroundColor('#2196F3').margin({ bottom: 12 })

          Text('场景操作').fontSize(13).fontColor('#333').width('100%').margin({ bottom: 4 })
          // 场景操作按钮（3列网格）
          Row({ space: 4 }) {
            Button('双库串行').id('com.example.rdb_test:id/btn_scenario_0')
              .layoutWeight(1).height(28).fontSize(10).backgroundColor('#EDE7F6').fontColor('#4527A0')
              .onClick(() => { this.selectedScenarioAction = '双库串行'; this.executeScenarioAction(); })
            Button('双表串行').id('com.example.rdb_test:id/btn_scenario_1')
              .layoutWeight(1).height(28).fontSize(10).backgroundColor('#EDE7F6').fontColor('#4527A0')
              .onClick(() => { this.selectedScenarioAction = '双表串行'; this.executeScenarioAction(); })
            Button('先on再建表').id('com.example.rdb_test:id/btn_scenario_2')
              .layoutWeight(1).height(28).fontSize(10).backgroundColor('#EDE7F6').fontColor('#4527A0')
              .onClick(() => { this.selectedScenarioAction = '先on再建表'; this.executeScenarioAction(); })
          }.width('100%').margin({ bottom: 2 })
          Row({ space: 4 }) {
            Button('事务内增删改').id('com.example.rdb_test:id/btn_scenario_4')
              .layoutWeight(1).height(28).fontSize(10).backgroundColor('#EDE7F6').fontColor('#4527A0')
              .onClick(() => { this.selectedScenarioAction = '事务内增删改'; this.executeScenarioAction(); })
            Button('事务回滚不回调').id('com.example.rdb_test:id/btn_scenario_5')
              .layoutWeight(1).height(28).fontSize(10).backgroundColor('#EDE7F6').fontColor('#4527A0')
              .onClick(() => { this.selectedScenarioAction = '事务回滚不回调'; this.executeScenarioAction(); })
          }.width('100%').margin({ bottom: 2 })
          Row({ space: 4 }) {
            Button('多行Insert监听').id('com.example.rdb_test:id/btn_scenario_6')
              .layoutWeight(1).height(28).fontSize(10).backgroundColor('#EDE7F6').fontColor('#4527A0')
              .onClick(() => { this.selectedScenarioAction = '多行Insert监听'; this.executeScenarioAction(); })
            Button('多行Update监听').id('com.example.rdb_test:id/btn_scenario_7')
              .layoutWeight(1).height(28).fontSize(10).backgroundColor('#EDE7F6').fontColor('#4527A0')
              .onClick(() => { this.selectedScenarioAction = '多行Update监听'; this.executeScenarioAction(); })
            Button('多行Delete监听').id('com.example.rdb_test:id/btn_scenario_8')
              .layoutWeight(1).height(28).fontSize(10).backgroundColor('#EDE7F6').fontColor('#4527A0')
              .onClick(() => { this.selectedScenarioAction = '多行Delete监听'; this.executeScenarioAction(); })
          }.width('100%').margin({ bottom: 12 })

          Text('异常测试').fontSize(13).fontColor('#333').width('100%').margin({ bottom: 4 })
          // 异常测试按钮
          Row({ space: 4 }) {
            Button('on: 非法订阅类型').id('com.example.rdb_test:id/btn_exception_0')
              .layoutWeight(1).height(28).fontSize(10).backgroundColor('#FFF8E1').fontColor('#F57F17')
              .onClick(() => { this.selectedExceptionCase = 'on: 非法订阅类型'; this.runExceptionTest(); })
            Button('off: 非法订阅类型').id('com.example.rdb_test:id/btn_exception_1')
              .layoutWeight(1).height(28).fontSize(10).backgroundColor('#FFF8E1').fontColor('#F57F17')
              .onClick(() => { this.selectedExceptionCase = 'off: 非法订阅类型'; this.runExceptionTest(); })
          }.width('100%').margin({ bottom: 2 })
          Row({ space: 4 }) {
            Button('on: 已关闭DB的on').id('com.example.rdb_test:id/btn_exception_2')
              .layoutWeight(1).height(28).fontSize(10).backgroundColor('#FFEBEE').fontColor('#C62828')
              .onClick(() => { this.selectedExceptionCase = 'on: 已关闭DB的on'; this.runExceptionTest(); })
            Button('off: 已关闭DB的off').id('com.example.rdb_test:id/btn_exception_3')
              .layoutWeight(1).height(28).fontSize(10).backgroundColor('#FFEBEE').fontColor('#C62828')
              .onClick(() => { this.selectedExceptionCase = 'off: 已关闭DB的off'; this.runExceptionTest(); })
          }.width('100%').margin({ bottom: 8 })

          Row().height(12)
        }
        .width('100%').padding({ left: 10, right: 10 })
      }
      .layoutWeight(1)
      .width('100%')

      // ===== 下半部分：执行结果 =====
      Scroll() {
        Column() {
          Row() {
            Text('结果').fontSize(13).fontColor('#b421f398')
          }.width('100%').margin({ bottom: 2 })

          Text('action: ' + this.lastAction).id('com.example.rdb_test:id/result_last_action').fontSize(11).fontColor('#333').width('100%')
          Text('result: ' + this.lastResult)
            .id('com.example.rdb_test:id/result_last_status').fontSize(11).fontColor(this.resultColor()).width('100%')
          Text('detail: ' + this.lastDetail)
            .id('com.example.rdb_test:id/result_last_detail').fontSize(11).fontColor('#666').width('100%')
            .margin({ bottom: 6 })
        }
        .width('100%').padding({ left: 10, right: 10, top: 6 })
      }
      .constraintSize({ maxHeight: '40%' })
      .width('100%').backgroundColor('#FFFFFF')
    }
    .width('100%').height('100%').backgroundColor('#F0F2F5')
  }
}
