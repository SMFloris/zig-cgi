const std = @import("std");

pub fn main() anyerror!void {
    const stdout = std.io.getStdOut().writer();
    try stdout.print("Content-type: text/html\n\n", .{});
    try stdout.print("Hello, World.", .{});
}

test "basic test" {
    try std.testing.expectEqual(10, 3 + 7);
}
