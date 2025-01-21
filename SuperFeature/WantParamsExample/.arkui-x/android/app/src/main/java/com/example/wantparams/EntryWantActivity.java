package com.example.wantparams;

import android.app.Activity;
import android.content.Intent;
import android.os.Bundle;
import android.widget.Button;
import android.widget.TextView;
import org.json.JSONException;
import org.json.JSONObject;
import java.util.Arrays;

import ohos.ace.adapter.WantParams;

/**
 * EntryWantActivity is a class that utilizes WantParams. This class demonstrates the usage of
 * the addValue, getValue, and toWantParamsString methods within WantParams.
 *
 * @since 2025-01-18
 */
public class EntryWantActivity extends Activity {
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.want);

        Button btnGetValue = findViewById(R.id.btn_get_value);
        TextView textView = findViewById(R.id.text_view);

        Intent intent = getIntent();
        String params = intent.getStringExtra("params"); // 获取ETS传递而来的Want Parameter数据。
        // 格式化从ETS传递来的数据信息
        String formattedJson;
        JSONObject jsonObject;
        try {
            jsonObject = new JSONObject(params);
            formattedJson = jsonObject.toString(2);
        } catch (JSONException e) {
            throw new RuntimeException(e);
        }
        // textView显示ArkTS传递而来的Want Parameter数据
        textView.setText(String.format("ArkTS->原生: \n%s", formattedJson));

        // 自定义WantParams数据
        WantParams wantParams = new WantParams();
        wantParams.addValue("stringKey", "normal")
                .addValue("intKey", 123)
                .addValue("doubleKey", -6.9)
                .addValue("boolKey", true)
                .addValue("arrayKey", new boolean[] { false, true })
                .addValue("wantParamsKey",
                        new WantParams()
                                .addValue("strKey", "It's me."));
        // 通过getValue获取WantParams中的值
        StringBuilder stringBuilder = new StringBuilder();
        stringBuilder.append("GetValue:\n");
        Object obj = wantParams.getValue("stringKey");
        if (obj instanceof String) {
            stringBuilder.append("String: ").append((String) obj).append(",\n");
        }
        obj = wantParams.getValue("intKey");
        if (obj instanceof Integer) {
            stringBuilder.append("Int: ").append(obj).append(",\n");
        }
        obj = wantParams.getValue("doubleKey");
        if (obj instanceof Double) {
            stringBuilder.append("Double: ").append(obj).append(",\n");
        }
        obj = wantParams.getValue("boolKey");
        if (obj instanceof Boolean) {
            stringBuilder.append("Boolean: ").append(obj).append(",\n");
        }
        obj = wantParams.getValue("arrayKey");
        if (obj instanceof boolean[]) {
            stringBuilder.append("Array: ").append(Arrays.toString((boolean[]) obj)).append(",\n");
        }
        obj = wantParams.getValue("wantParamsKey");
        if (obj instanceof WantParams) {
            stringBuilder.append("WantParams: ").append(((WantParams) obj).toWantParamsString());
        }

        // 将WantParams数据显示在TextView中
        btnGetValue.setOnClickListener(v -> {
            textView.setText(stringBuilder.toString());
        });
    }
}
