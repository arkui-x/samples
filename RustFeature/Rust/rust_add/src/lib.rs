use napi_derive_ohos::napi;

#[napi]
pub fn add(left: u32, right: u32) -> u32 {
  left + right
}

#[napi]
pub fn subtract(left: i32, right: i32) -> i32 {
  left - right
}
