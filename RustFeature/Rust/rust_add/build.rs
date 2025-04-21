use std::env;
use std::path::Path;

fn main() {
    napi_build_ohos::setup();
    // 指定某个源文件如果有修改就重新编译
    println!("cargo:rerun-if-changed=src/lib.rs");

    // OH 构建配置
    if env::var("OHOS_BUILD").is_ok() {
        return;
    }

	// 获取目标平台架构，如 aarch64-linux-android
    let target = env::var("TARGET").unwrap_or_default();

    // Android 构建配置
    if target.contains("android") {
    	let arch = env::var("CARGO_CFG_TARGET_ARCH").unwrap_or_default();
        let arch_folder = match arch.as_str() {
            "aarch64" => "arm64-v8a",
            "arm"     => "armeabi-v7a",
            "x86_64"  => "x86_64",
            other => panic!("Unsupported Android architecture: {}", other),
        };

		// 根据项目的实际目录进行修改
        let lib_path = Path::new("../RustDev/.arkui-x/android/app/libs/")
            .join(arch_folder);

        println!("cargo:rustc-link-search=native={}", lib_path.display());
    	println!("cargo:rustc-link-lib=arkui_android");
    }

    // iOS 构建配置
    if target.contains("apple") {
    	// 获取项目根目录的绝对路径
        let manifest_dir = env::var("CARGO_MANIFEST_DIR").unwrap();
        // 根据项目的实际目录进行修改
        let framework_dir = Path::new(&manifest_dir)
            .join("../RustDev/.arkui-x/ios/frameworks/libarkui_ios.xcframework");

        let platform_subdir = if target.contains("simulator") {
            "ios-arm64_x86_64-simulator"
        } else {
            "ios-arm64"
        };
        let framework_path = framework_dir.join(platform_subdir);

		// 输出绝对路径（但路径是基于项目结构的相对路径生成的）
        println!("cargo:rustc-link-search=framework={}", framework_path.display());
        println!("cargo:rustc-link-lib=framework=libarkui_ios");
        println!("cargo:rustc-link-lib=framework=JavaScriptCore");
        println!("cargo:rustc-link-lib=framework=CoreFoundation");
        println!("cargo:rustc-link-lib=framework=UIKit");
    }
}