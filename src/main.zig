const std = @import("std");
const cgi = @import("./cgi.zig");

pub fn main() anyerror!void {
    const stdout = std.io.getStdOut().writer();
    try stdout.print("Content-type: text/html\n\n", .{});
    try stdout.print("Hello, World.", .{});
    const config = cgi.Config.init();
    try stdout.print("Damn {s}\n\n", .{config.Content.MultipartBoundary});
}

test "basic test" {
    try std.testing.expectEqual(10, 3 + 7);
}
