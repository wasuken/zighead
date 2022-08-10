const std = @import("std");

fn strlen(ptr: [*]const u8) usize {
  var count: usize = 0;
  while (ptr[count] != 0) : (count += 1) {}
  return count;
}

pub fn main() anyerror!void {
  if(std.os.argv.len <= 1){
    std.log.err("引数エラー\n", .{});
    return;
  }
  // filename
  const imarg1: [*:0]u8 = std.os.argv[1];
  const fname: []const u8 = imarg1[0..strlen(imarg1)];

  // linum
  var linum: i32  = 10;
  if(std.os.argv.len > 2){
    const imarg2: [*:0]u8 = std.os.argv[2];
    linum = try std.fmt.parseInt(i32, imarg2[0..strlen(imarg2)], 10);
  }

  var fs = try std.fs.cwd().openFile(fname, .{});
  defer fs.close();
  var bufr = std.io.bufferedReader(fs.reader());
  var ins = bufr.reader();
  var buf: [1024]u8 = undefined;
  var until: i32 = linum;
  while(try ins.readUntilDelimiterOrEof(&buf, '\n')) |line|{
    if (until > 0){
      std.debug.print("{s}\n", .{line});
    }else{
      break;
    }
    until-=1;
  }
}

test "basic test" {}
