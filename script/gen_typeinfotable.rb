#! /usr/bin/ruby
# gen_typeinfotable.rb
#                           wookay.noh at gmail.com

#UIKitHeaders = '/Applications/Xcode.app/Contents/Developer/Platforms/iPhoneSimulator.platform/Developer/SDKs/iPhoneSimulator6.0.sdk/System/Library/Frameworks/UIKit.framework/Headers/'
UIKitHeaders = '/Applications/Xcode_45.app/Contents/Developer/Platforms/iPhoneSimulator.platform/Developer/SDKs/iPhoneSimulator6.0.sdk/System/Library/Frameworks/UIKit.framework/Headers/'

found = false
for file in Dir[UIKitHeaders+'*.h']
  found = true
  break
end
if not found
  puts "Not found UIKIt headers in #{UIKitHeaders}"
  exit
end

IGNORE_TYPES = ['SEL', 'CGFloat', 'float', 'CGAffineTransform', 'UIAccelerationValue', 'NSInteger', 'NSTimeInterval', 'CFTimeInterval', 'NSUInteger', 'CGPathRef']
SPACE = ' '
COMMA = ','
EQUAL = '='
LF = "\n"
def parse_header file
  type_dict = {}
  h = open(file).read  
  pat = /typedef enum \{[^\}]*\} \w*;/m
  h.scan pat do |e|
    pat = /\} \w*;/
    type_name = e.scan(pat).first.gsub('} ','').gsub(/;$/,'')
    ary = []
    for line in e.split(LF)
      if line =~ /^typedef/
        next
      end
      pat = /^\s*\w{1,}/
      m = line.match(pat)
      if m
        if line.include? EQUAL
          if line.include? '-1'
            next
          end
        end
        ary.push m[0].strip
      end
    end
    type_dict[ type_name ] = ary
  end

  pat = /typedef NS_ENUM\(NSInteger, \w*\) \{[^\}]*\};/m
  h.scan pat do |e|
    pat = /, (\w*)\) \{/
    type_name = e.scan(pat)
    ary = []
    for line in e.split(LF)
      if line =~ /^typedef/
        next
      end
      pat = /^\s*\w{1,}/
      m = line.match(pat)
      if m
        if line.include? EQUAL
        end
        ary.push m[0].strip
      end
    end
    type_dict[ type_name ] = ary
  end

  pat = /typedef NS_OPTIONS\(NSUInteger, \w*\) \{[^\}]*\} NS_ENUM_AVAILABLE_IOS\(\d*_\d*\);/m
  h.scan pat do |e|
    pat = /, (\w*)\) \{/
    type_name = e.scan(pat)
    ary = []
    for line in e.split(LF)
      if line =~ /^typedef/
        next
      end
      pat = /^\s*\w{1,}/
      m = line.match(pat)
      if m
        if line.include? EQUAL
        end
        ary.push m[0].strip
      end
    end
    type_dict[ type_name ] = ary
  end

  klass_dict = {}
  pat = /@interface \w*.*@end$/m
  klass_part = h.scan(pat).first
  if nil == klass_part
  else
    pat = /@interface\W+(\w*)\W+/
    klass_name = klass_part.split(SPACE)[1]

    pat = /@property[ ]?\(nonatomic.*;/ #\(nonatomic\)\s*\w* \w*;/
    klass_part.scan pat do |w|
      a = w.gsub(/;$/,'').gsub(/__OSX_AVAILABLE_.*$/,'').split(SPACE)
      type = a[-2]
      prop = a[-1]
      if type.include? '*'
        next
      end
      if type.include? '<'
        next
      end
      if type == 'id'
        next
      end
      case type
      when IGNORE_TYPES
      else
        case prop
        when /NS_AVAILABLE_IOS.*/
        when /NS_DEPRECATED_IOS.*/
        when /UI_APPEARANCE_SELECTOR/
        when /\)$/
	    else
          klass_dict[ [klass_name, prop.gsub('*','')] ] = type
        end
      end
    end
  end

  [type_dict, klass_dict]
end

all_type_dict = {}
all_klass_dict = {}
for file in Dir[UIKitHeaders+'*.h']
  type_dict, klass_dict = parse_header file
  all_type_dict.merge! type_dict
  all_klass_dict.merge! klass_dict
end

typeTable = []
for k,v in all_type_dict
  typeTable.push %Q<\t\t@"#{k}", _w(@"#{v.join(SPACE)}"),>
end

klassTable = []
for k,v in all_klass_dict
  klassTable.push %Q<\t\t@"#{k.join(SPACE)}", @"#{v}",>
end

table = <<EOF
-(void) load_typedef_table {
	self.typedefTable = [NSDictionary dictionaryWithKeysAndObjects: 
#{typeTable.sort.join(LF)}
	nil];
}

-(void) load_property_table {
	self.propertyTable = [NSDictionary dictionaryWithKeysAndObjects: 
#{klassTable.sort.join(LF)}
	nil];
}
EOF


typeInfoTable_footer = <<EOF
-(id) init {
	self = [super init];
	if (self) {
       [self load_typedef_table];
       [self load_property_table];
	}
	return self;
}

- (void)dealloc {
	[typedefTable release];
	[propertyTable release];
    [super dealloc];
}

@end
EOF

gen_marker = "//GEN"
path = "../libcat/Console/manipulator/TypeInfoTable.m"
prev_code = open(path, 'r').read.split(gen_marker).first
typeInfoTable_m = <<EOF
#{prev_code}#{gen_marker}
#{table}
#{typeInfoTable_footer}
EOF
open(path, 'w') do |f|
  puts "Written generated info in #{path}"
  f.write typeInfoTable_m
end
