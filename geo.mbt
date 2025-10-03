///|
pub(all) struct GeoCoordinates {
  longitude : Double
  latitude : Double
}

///|
pub fn GeoCoordinates::to_array(self : GeoCoordinates) -> Array[String] {
  [self.longitude.to_string(), self.latitude.to_string()]
}

///|
pub(all) enum GeoUnits {
  Meters
  Kilometers
  Miles
  Feet
}

///|
pub(all) struct GeoSearchByBox {
  width : Int
  height : Int
  unit : GeoUnits
}

///|
pub fn GeoSearchByBox::to_array(self : GeoSearchByBox) -> Array[String] {
  [self.width.to_string(), self.height.to_string(), self.unit.to_string()]
}

///|
pub impl Show for GeoUnits with output(self : GeoUnits, logger : &Logger) -> Unit {
  logger.write_string(self.to_string())
}

///|
pub impl Show for GeoUnits with to_string(self : GeoUnits) -> String {
  match self {
    Meters => "m"
    Kilometers => "km"
    Miles => "mi"
    Feet => "ft"
  }
}

// ============ 地理位置命令 ============

///|
pub async fn RedisClient::geoadd(
  self : RedisClient,
  key : String,
  longitude : String,
  latitude : String,
  value : String,
) -> RedisInt {
  self.send(["GEOADD", key, longitude, latitude, value]).to_int()
}

///|
pub async fn RedisClient::geoadd_multiple(
  self : RedisClient,
  key : String,
  coordinates : Array[GeoCoordinates],
) -> RedisInt {
  let args = ["GEOADD", key, ..coordinates.map(c => c.to_array()).flatten()]
  self.send(args).to_int()
}

///|
pub async fn RedisClient::geodist(
  self : RedisClient,
  key : String,
  member1 : String,
  member2 : String,
) -> RedisBulkString {
  self.send(["GEODIST", key, member1, member2]).to_bulk_string()
}

///|
pub async fn RedisClient::geodist_unit(
  self : RedisClient,
  key : String,
  member1 : String,
  member2 : String,
  unit : GeoUnits,
) -> RedisBulkString {
  self
  .send(["GEODIST", key, member1, member2, unit.to_string()])
  .to_bulk_string()
}

///|
pub async fn RedisClient::geohash(
  self : RedisClient,
  key : String,
  members : Array[String],
) -> RedisArray {
  let args = ["GEOHASH", key, ..members]
  self.send(args).to_array()
}

///|
pub async fn RedisClient::geopos(
  self : RedisClient,
  key : String,
  members : Array[String],
) -> RedisArray {
  let args = ["GEOPOS", key, ..members]
  self.send(args).to_array()
}

///|
pub async fn RedisClient::georadius(
  self : RedisClient,
  key : String,
  longitude : String,
  latitude : String,
  radius : String,
  unit : GeoUnits,
) -> RedisArray {
  self
  .send(["GEORADIUS", key, longitude, latitude, radius, unit.to_string()])
  .to_array()
}

///|
pub async fn RedisClient::georadius_ro(
  self : RedisClient,
  key : String,
  longitude : String,
  latitude : String,
  radius : String,
  unit : GeoUnits,
) -> RedisArray {
  self
  .send(["GEORADIUS_RO", key, longitude, latitude, radius, unit.to_string()])
  .to_array()
}

///|
pub async fn RedisClient::georadiusbymember(
  self : RedisClient,
  key : String,
  value : String,
  radius : String,
  unit : GeoUnits,
) -> RedisArray {
  self
  .send(["GEORADIUSBYMEMBER", key, value, radius, unit.to_string()])
  .to_array()
}

///|
pub async fn RedisClient::georadiusbymember_ro(
  self : RedisClient,
  key : String,
  value : String,
  radius : String,
  unit : GeoUnits,
) -> RedisArray {
  self
  .send(["GEORADIUSBYMEMBER_RO", key, value, radius, unit.to_string()])
  .to_array()
}

///|
pub async fn RedisClient::geosearch(
  self : RedisClient,
  key : String,
  member_ : String,
  radius : String,
  unit : GeoUnits,
) -> RedisArray {
  self
  .send([
    "GEOSEARCH",
    key,
    "FROMMEMBER",
    member_,
    "BYRADIUS",
    radius,
    unit.to_string(),
  ])
  .to_array()
}

///|
pub async fn RedisClient::geosearch_box(
  self : RedisClient,
  key : String,
  coordinates : GeoCoordinates,
  search_box : GeoSearchByBox,
) -> RedisArray {
  self
  .send(
    [
      "GEOSEARCH",
      key,
      "FROMLONLAT",
      ..coordinates.to_array(),
      "BYBOX",
      ..search_box.to_array(),
    ],
  )
  .to_array()
}

///|
pub async fn RedisClient::geosearchstore(
  self : RedisClient,
  source : String,
  destination : String,
  member_ : String,
  radius : String,
  unit : GeoUnits,
) -> RedisInt {
  self
  .send([
    "GEOSEARCHSTORE",
    source,
    destination,
    "FROMMEMBER",
    member_,
    "BYRADIUS",
    radius,
    unit.to_string(),
  ])
  .to_int()
}

///|
pub async fn RedisClient::geosearchstore_with_dist(
  self : RedisClient,
  destination : String,
  source : String,
  member_ : String,
  radius : Double,
  unit : GeoUnits,
) -> RedisInt {
  self
  .send([
    "GEOSEARCHSTORE",
    destination,
    source,
    "FROMMEMBER",
    member_,
    "BYRADIUS",
    radius.to_string(),
    unit.to_string(),
    "STOREDIST",
  ])
  .to_int()
}

///|
pub async fn RedisClient::geosearch_with_dist(
  self : RedisClient,
  key : String,
  member_ : String,
  radius : Double,
  unit : GeoUnits,
) -> RedisArray {
  self
  .send([
    "GEOSEARCH",
    key,
    "FROMMEMBER",
    member_,
    "BYRADIUS",
    radius.to_string(),
    unit.to_string(),
    "WITHDIST",
  ])
  .to_array()
}

///|
pub async fn RedisClient::geosearchstore_box(
  self : RedisClient,
  destination : String,
  source : String,
  from_member : String,
  search_box : GeoSearchByBox,
) -> RedisInt {
  self
  .send(
    [
      "GEOSEARCHSTORE",
      destination,
      source,
      "FROMMEMBER",
      from_member,
      "BYBOX",
      ..search_box.to_array(),
    ],
  )
  .to_int()
}
