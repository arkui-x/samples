import { CommonModifier } from "@kit.ArkUI"


const TEST_TAG: string = "AttributeModifier";


class MyModifier extends CommonModifier {
  applyNormalAttribute(instance: CommonAttribute): void {
    super.applyNormalAttribute?.(instance);
  }

  public setGroup1(): void {
    this.borderStyle(BorderStyle.Dotted)
    this.borderWidth(8)
  }

  public setGroup2(): void {
    this.borderStyle(BorderStyle.Dashed)
    this.borderWidth(8)
  }
}


@Component
struct MyImage1 {
  @Link modifier: CommonModifier

  build() {
    Image($r("app.media.icon")).attributeModifier(this.modifier as MyModifier)
  }
}


@Entry
@Component
struct Index {
  @State myModifier: CommonModifier = new MyModifier().width(100).height(100).margin(10)
  index: number = 0;

  build() {
    Column() {
      Button($r("app.string.ModifierAbility_label"))
        .margin(10)
        .onClick(() => {
          console.log(TEST_TAG, "onClick")
          this.index++;
          if (this.index % 2 === 1) {
            (this.myModifier as MyModifier).setGroup1()
            console.log(TEST_TAG, "setGroup1")
          } else {
            (this.myModifier as MyModifier).setGroup2()
            console.log(TEST_TAG, "setGroup2")
          }
        })
      MyImage1({ modifier: this.myModifier })
    }
    .width('100%')
  }
}