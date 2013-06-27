
#class define
class TestObject(object):
	def __init__(self, name):
		super(TestObject, self).__init__()
		self.name = name
		
	def print_name(self):
		print("self.name:" + self.name)

to1 = TestObject('liudehua')
to1.print_name()
def to1_print_name(self):
	print("replace:" + self.name)
import new
to1.__class__.print_name = new.instancemethod(to1_print_name, None, to1.__class__)
to1.print_name()

class TestSubObject(TestObject):
	#__init__ method:
	#	ts = TestSubObject("liudehua")
	#	actually is:
	#	ts = object.__new__(TestSubObject)
	#	TestSubObject.__init__(ts, "liudehua")
	def __init__(self, name="zhangxueyou"):
		super(TestSubObject, self).__init__(name)

ts = TestSubObject()
ts.print_name()

#string
print(ts.name[0]);
print(ts.name[-1]);
print(len(ts.name[0]));
print(ts.name[0:2]);
print(ts.name[:]);
print(ts.name[:2]);
print(ts.name[2:]);
print(ts.name * 2);
name = ts.name
print(name.find("xue"));
print(name.replace("zhang", "liu"));
print(name.split("g"));
name = name.upper();
print(name);
print(name.lower());
name = name + "\n\n    "
print(name);
print(name.rstrip());
print("%s, eggs, and %s" % ("spam", "SPAM!"));

print(dir(name))
name = name.rstrip()
print(name.isalpha());
print(name.isdigit());
print(help(name.join));
print(name.join("12345"));
print(ord("\n"));

#Lists
L = [123, "abc", 1.23];
print(L);
print(len(L));
L += [4, 5, 6];
print(L);
print(L[:-1]);
L.append("NI");
print(L);
L.pop(2);
print(L);
L.sort();
print(L);
L.reverse();
print(L);
#print(L[100]);
#L[100] = 1;
#print(L[100]);
M = [
	[1, 2, 3],
	[4, 5, 6],
	[7, 8, 9],
];
print(M);
print(M[0]);
print(M[0][1]);
col2 = [row[1] for row in M];
print(col2);
print([row[1] + 1 for row in M]);
print([row[1] for row in M if row[1] % 2 == 0]);

#Dictionaries
D = {"food" : "Spam", "quantity" : 4, "color" : "pink"};
print(D);
print(D["food"]);
D["quantity"] += 1;
print(D);
D["name"] = "liudehua";
print(D);
print(dir(D));
for key in D.keys():
	print(key + ",", D[key]);
if not "f" in D:
	print("missing")
print(D.get("f", "replace"));
squares = [x ** 2 for x in [1, 2, 3, 4, 5]];
print(squares);

#Tuples
T = (1, 2, 3, 4, 5)
print(T);
print(T + (6, 7));
print(T[0]);
print(T.index(4));
print(T.count(4));

#Files
"""
f = open("test.txt", "w")
f.write("hello\n");
f.close();
"""

#Other
X = set("spam")
Y = {"h", "a", "m"};
print(X, Y);
print(X & Y);
print(X | Y);
print(X - Y);
print(type(X));
if type(X) == type(set()):
	print("is set");

if isinstance(X, set):
	print("is instance of set");

#yield
def yield_test():
	print("yield_test");
	y1 = yield "y1"
	print("y1:" + y1);
	y2 = yield "y2"
	print("y2:" + y2);
c = yield_test();
r1 = c.next();
print("r1:" + r1);
r2 = c.send("param1");
print(r1, r2);
