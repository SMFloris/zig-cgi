const std = @import("std");

fn getBoundaryFromString(s: []const u8) []const u8 {
  const boundary = "boundary=";
  const boundaryStart: usize = std.ascii.indexOfIgnoreCase(s, boundary) orelse 0;
  if (boundaryStart == 0) {
    return "";
  } 
 
  var boundaryCurrentPos = boundaryStart + boundary.len;
  while(boundaryCurrentPos < s.len and !std.ascii.isSpace(s[boundaryCurrentPos]) and s[boundaryCurrentPos] != 0) {
    boundaryCurrentPos += 1;
  }

  return s[boundaryStart+boundary.len..boundaryCurrentPos];
}

fn getContentTypeFromString(s: []const u8) []const u8 {
  const separatorPos: usize = std.ascii.indexOfIgnoreCase(s, ";") orelse 0;
  if(separatorPos == 0) {
    return s;
  }
  return s[0..separatorPos];
}


test "no content type" {
  try std.testing.expectEqualStrings("", getContentTypeFromString(""));
}

test "just content type" {
  try std.testing.expectEqualStrings("application/json", getContentTypeFromString("application/json"));
}

test "separator content type" {
  try std.testing.expectEqualStrings("application/json", getContentTypeFromString("application/json;"));
}

test "empty boundary" {
  try std.testing.expectEqualStrings("", getBoundaryFromString("application/json"));
}

test "separator with boundary content type" {
  try std.testing.expectEqualStrings("application/json", getContentTypeFromString("application/json; boundary=12321321afsafsafasfasfas"));
  try std.testing.expectEqualStrings("12321321afsafsafasfasfas", getBoundaryFromString("application/json; boundary=12321321afsafsafasfasfas  afafa"));
}

const Content = struct {
  Type: []const u8,
  Length: usize,
  MultipartBoundary: []const u8,


  fn getContentFromContentType(contentType: []const u8) Content {
    if (contentType.len == 0) {
      return Content {
        .Type = "",
        .Length = 0,
        .MultipartBoundary = ""
      };
    }

    var truncatedContentType = contentType;
    if (contentType.len > 1023) {
      truncatedContentType = contentType[0..1023 :0];
    }

    return Content {
      .Type = getContentTypeFromString(truncatedContentType),
      .Length = std.fmt.parseInt(usize, std.os.getenv("CONTENT_LENGTH") orelse "", 10) catch 0,
      .MultipartBoundary = getBoundaryFromString(truncatedContentType)
    };
  }

  pub fn init() Content {
    const contentType = std.os.getenv("CONTENT_TYPE") orelse "";
    return getContentFromContentType(contentType);
  }

};

pub const Config = struct {
  ServerSoftware: []const u8,
  ServerName: []const u8,
  GatewayInterface: []const u8,
  ServerProtocol: []const u8,
  ServerPort: []const u8,
  RequestMethod: []const u8,
  PathInfo: []const u8,
  PathTranslated: []const u8,
  ScriptName: []const u8,
  QueryString: []const u8,
  RemoteHost: []const u8,
  RemoteAddr: []const u8,
  AuthType: []const u8,
  RemoteUser: []const u8,
  RemoteIdent: []const u8,

  Content: Content,

  Accept: []const u8,
  UserAgent: []const u8,
  Referrer: []const u8,
  Cookie: []const u8,


  pub fn init() Config {
    var config = Config {
      .ServerSoftware = std.os.getenv("SERVER_SOFTWARE") orelse "",
      .ServerName = std.os.getenv("SERVER_NAME") orelse "",
      .GatewayInterface = std.os.getenv("GATEWAY_INTERFACE") orelse "",
      .ServerProtocol = std.os.getenv("SERVER_PROTOCOL") orelse "",
      .ServerPort = std.os.getenv("SERVER_PORT") orelse "",
      .RequestMethod = std.os.getenv("REQUEST_METHOD") orelse "",
      .PathInfo = std.os.getenv("PATH_INFO") orelse "",
      .PathTranslated = std.os.getenv("PATH_TRANSLATED") orelse "",
      .ScriptName = std.os.getenv("SCRIPT_NAME") orelse "",
      .QueryString = std.os.getenv("QUERY_STRING") orelse "",
      .RemoteHost = std.os.getenv("REMOTE_HOST") orelse "",
      .RemoteAddr = std.os.getenv("REMOTE_ADDR") orelse "",
      .AuthType = std.os.getenv("AUTH_TYPE") orelse "",
      .RemoteUser = std.os.getenv("REMOTE_USER") orelse "",
      .RemoteIdent = std.os.getenv("REMOTE_IDENT") orelse "",
      .Accept = std.os.getenv("HTTP_ACCEPT") orelse "",
      .UserAgent = std.os.getenv("HTTP_USER_AGENT") orelse "",
      .Referrer = std.os.getenv("HTTP_REFERER") orelse "",
      .Cookie = std.os.getenv("HTTP_COOKIE") orelse "",
      .Content = Content.init()
    };

    return config;
  }
};
