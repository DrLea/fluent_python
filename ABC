import abc


class Rand(abc.ABC):
    @classmethod  # there is also abstractclassmethod but it became useless after multilayer decoraters became available
    @abc.abstractmethod  # order is importand in multilayer decorators, and abc always must be first
    def randint(self, a: int, b: int) -> int:
        pass


class A:
    pass

class B:
    pass

class C(A, B):
    pass

try:
    class E(B, C):
        pass
except Exception as e:
    print(e)

class E(C, B):
    pass

class F(E):
    pass

print(F.__mro__)


# it makes Python believe that Poker is subclass of Rand,
# but in fact it is just virtual subclass and we will have 
# an error if we try to call any method withoud defining it
@Rand.register
class Poker(list):
    pass

print(Poker.__mro__)  # it is not listed in __mro__
poker = Poker()
try:
    poker.randint(0, 10)  # and methods are also not shared
except Exception as e:
    print(e)

# It is always suggested to have ABC classes (protocols) with 1 max 2 methods
# This is GOlang approach

class Reader(abc.ABC):
    @abc.abstractmethod
    def read(self) -> str:
        pass

class Writer(abc.ABC):
    @abc.abstractmethod
    def write(self, s: str) -> None:
        pass

class IO(Reader, Writer):
    def read(self):
        return "Hello"

    def write(self, s: str):
        print(s)

# this approach helps us use classes we need and don't use others (reusability)
# Goose typing can easily find out that IO can write and read by using isinstance(io, Reader) issubclass(IO, Writer)
