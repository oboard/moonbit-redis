///|
pub(all) enum Bit {
  Zero
  One
}

///|
pub(all) enum BitFieldEncoding {
  U8
  U16
  U32
  U64
  I8
  I16
  I32
  I64
}

///|
pub(all) enum BitFieldOperation {
  Get(encoding~ : BitFieldEncoding, offset~ : Int)
  Set(encoding~ : BitFieldEncoding, offset~ : Int, value~ : Bit)
  Incrby(encoding~ : BitFieldEncoding, offset~ : Int, value~ : Int)
  Overflow(behavior~ : String)
}

///|
pub impl Show for BitFieldEncoding with output(self, logger : &Logger) -> Unit {
  logger.write_string(self.to_string())
}

///|
pub impl Show for BitFieldEncoding with to_string(self) -> String {
  match self {
    U8 => "u8"
    U16 => "u16"
    U32 => "u32"
    U64 => "u64"
    I8 => "i8"
    I16 => "i16"
    I32 => "i32"
    I64 => "i64"
  }
}

///|
pub fn BitFieldOperation::to_array(self : BitFieldOperation) -> Array[String] {
  match self {
    Get(encoding~, offset~) => ["GET", encoding.to_string(), offset.to_string()]
    Set(encoding~, offset~, value~) =>
      ["SET", encoding.to_string(), offset.to_string(), value.to_string()]
    Incrby(encoding~, offset~, value~) =>
      ["INCRBY", encoding.to_string(), offset.to_string(), value.to_string()]
    Overflow(behavior~) => ["OVERFLOW", behavior]
  }
}

///|
pub impl Show for Bit with output(self : Bit, logger : &Logger) -> Unit {
  logger.write_string(self.to_string())
}

///|
pub impl Show for Bit with to_string(self : Bit) -> String {
  match self {
    Zero => "0"
    One => "1"
  }
}

// ============ 位操作命令 ============

///|
pub async fn RedisClient::setbit(
  self : RedisClient,
  key : String,
  offset : Int,
  value : Bit,
) -> RedisInt {
  self.send(["SETBIT", key, offset.to_string(), value.to_string()]).to_int()
}

///|
pub async fn RedisClient::getbit(
  self : RedisClient,
  key : String,
  offset : Int,
) -> RedisInt {
  self.send(["GETBIT", key, offset.to_string()]).to_int()
}

///|
pub async fn RedisClient::bitcount(
  self : RedisClient,
  key : String,
) -> RedisInt {
  self.send(["BITCOUNT", key]).to_int()
}

///|
pub async fn RedisClient::bitcount_range(
  self : RedisClient,
  key : String,
  start : Int,
  end : Int,
) -> RedisInt {
  self.send(["BITCOUNT", key, start.to_string(), end.to_string()]).to_int()
}

///|
pub async fn RedisClient::bitfield(
  self : RedisClient,
  key : String,
  operations : Array[BitFieldOperation],
) -> RedisArray {
  let args = ["BITFIELD", key, ..operations.map(op => op.to_array()).flatten()]
  self.send(args).to_array()
}

///|
pub async fn RedisClient::bitfield_ro(
  self : RedisClient,
  key : String,
  operations : Array[String],
) -> RedisArray {
  let args = ["BITFIELD_RO", key, ..operations]
  self.send(args).to_array()
}

///|
pub async fn RedisClient::bitop(
  self : RedisClient,
  operation : String,
  destkey : String,
  keys : Array[String],
) -> RedisInt {
  let args = ["BITOP", operation, destkey, ..keys]
  self.send(args).to_int()
}

///|
pub async fn RedisClient::bitpos(
  self : RedisClient,
  key : String,
  bit : Bit,
) -> RedisInt {
  self.send(["BITPOS", key, bit.to_string()]).to_int()
}

///|
pub async fn RedisClient::bitpos_range(
  self : RedisClient,
  key : String,
  bit : Bit,
  start : Int,
  end : Int,
) -> RedisInt {
  self
  .send(["BITPOS", key, bit.to_string(), start.to_string(), end.to_string()])
  .to_int()
}
