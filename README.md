## Chapter 1: The Python Data Model

- **Data Model Overview:**  
  The Python data model (via special methods like `__len__`, `__getitem__`, etc.) defines how objects integrate with language constructs and idioms.

- **Embrace Pythonic Conventions:**  
  Implementing "dunder" methods makes custom classes behave like built-in types, enabling more readable and idiomatic code.

- **Essential Special Methods:**  
  - `__repr__` / `__str__`: Control object string representations.
  - `__bytes__`: Defines `bytes(obj)` output.
  - `__format__`: Customizes formatting with `format()` or f-strings.
  - `__hash__` and `__eq__`: Required for hashable objects—objects that can serve as keys in dictionaries or elements in sets.

## Chapter 2: An Array of Sequences

- **Sequence Protocol:**  
  Implement `__getitem__` and `__len__` for sequence-like behavior. This unlocks features such as slicing and iteration.

- **Slicing & Indexing:**  
  Customizing slicing (`obj[start:end:step]`) allows for powerful subsetting of data in your custom sequences.

- **Mutable vs Immutable Sequences:**  
  - Immutable: `str`, `tuple`, `bytes`
  - Mutable: `list`, `bytearray`
  
  Mutability affects copying, hashing, and overall behavior in collections.

- **List Comprehensions & Generator Expressions:**  
  Prefer these for concise and efficient creation/transformation of sequences.

## Chapter 3: Dictionaries and Sets

- **Dictionaries & Sets Basics:**  
  - **Dictionaries:** Key-value pairs with O(1) average-time lookups.
  - **Sets:** Unordered collections of unique keys.

- **Hashability & Equality:**  
  - Keys must implement `__hash__` and `__eq__`.
  - Equal objects must have the same hash value.
  - Immutable types like `str`, `frozenset`, and `tuple` are typically hashable by default.

- **Insertion Order & Efficiency:**  
  - Python 3.7+ dictionaries remember insertion order.
  - Under the hood, dictionaries, sets, and lists expand their underlying storage (often doubling the capacity) once they hit a threshold, which can cause occasional inefficiencies or performance overhead during resizing operations.

- **Use Cases:**  
  - **Dictionaries:** Fast lookups by key, maintaining order.
  - **Sets:** Quick membership tests, removing duplicates efficiently.
 
## Raw book parts
- According to PEP 484, int is compatible with float, and float is compatible with complex. In practice, this makes sense because int supports all the operations float does, plus additional ones like &, |, <<, etc. As a result, int is also compatible with complex. For example, if i = 3, then i.real is 3 and i.imag is 0.
- **Closures** Scope (Замыкания)
  
Logic of Variable Lookup

When encountering a function definition, the Python bytecode compiler determines how to find a variable x encountered within it, guided by the following rules:
If there is a global x declaration, then x is taken from it and assigned to the global variable x at the module level.
If there is a nonlocal x declaration, then x is taken from it and assigned to the local variable x in the nearest enclosing function where x is defined.
If x is a parameter or is assigned a value in the body of the function, then x is a local variable.
If there is a reference to x, but it is neither assigned a value nor a parameter, then:

  - x is searched for in the local scopes of the bodies of enclosing functions (nonlocal scopes).
  - If it is not found in the enclosing scopes, it is read from the global scope of the module.
  - If it is not found in the global scope either, it is read from __builtins__.__dict__.

- **Accessors**

Simplicity in Code: Why You Shouldn't Overcomplicate Access Control

Ward Cunningham, the inventor of wikis and a pioneer of extreme programming, recommends asking yourself:

> "What is the simplest code that will do the job?"

The idea is to focus entirely on the goal. Implementing accessors (getters and setters) from the very beginning can be a distraction from that goal.

This proves that when developing a class, you should always start with the simplest version—keeping attributes public. If, later on, you decide to enforce access control with getter and setter methods, you can do so by implementing properties without modifying any existing code that accesses object components by name (e.g., `x` and `y`).

Example: Starting Simple

```python
class Protected:
    def __init__(self):
        self.x = 'top'
        self.y = 'secret'

    def say(self):
        print(self.x, self.y)
    
p = Protected()
p.say()
p.x = 'not a'
p.say()
```

Here, someone can accidentally modify our variables, which might become a concern. When we start caring about protected variables, we can enforce restrictions without refactoring the rest of the code.

Introducing Encapsulation

```python
class Protected:
    def __init__(self):
        self.__x = 'top'
        self.__y = 'secret'

    @property
    def x(self):
        return self.__x
    
    @property
    def y(self):
        return self.__y

    def say(self):
        print(self.x, self.y)

p = Protected()
p.say()
try:
    p.x = 'not a'
    p.say()
except Exception as e:
    print(e)
```

Now, direct modification of the variables is prevented, but we didn't need to change any of our method calls. This demonstrates that there's no need to be overly cautious from the beginning.

Java vs. Python: Misconceptions About Private and Protected Fields

Through years of teaching Python to Java developers, I've realized that many rely too much on Java's access control guarantees. However, in reality, Java's `private` and `protected` modifiers only protect against accidental modifications, not malicious intent.

They provide real security only when an application is deployed with a security manager (see [Java Security Manager](https://docs.oracle.com/javase/tutorial/essential/environment/security.html)). However, such deployments are rare, even in corporate environments.

Breaking Encapsulation with Reflection

In Java, introspection (known as "reflection" in Java terminology) can be used to access private fields:

```java
Confidential message = new Confidential("top secret text");
Field secretField = Confidential.class.getDeclaredField("secret");
secretField.setAccessible(true); // Lock bypassed!
System.out.println("message.secret = " + secretField.get(message));
```

This demonstrates that even in languages with strict access control mechanisms, encapsulation is not absolute. Instead of prematurely enforcing access restrictions, it's often better to start simple and only add constraints when they become necessary.

- **Type Systems in Python**
  
**Duck Typing 🦆**: "If it quacks like a duck, it's a duck!" Python assumes an object is valid if it has the expected behavior, without checking its type explicitly. Does not use isinstance()
[checks in runtime, structured]

**Goose Typing 🦢**: A stricter approach using Abstract Base Classes (ABC), where objects must explicitly declare compatibility. Introduced in Python 2.6. Uses isinstance()
[checks in runtime, nominal]

**Static Typing 📏**: Like in Java or C, types are declared in advance using the typing module (since Python 3.5) and verified by external tools.
[checks statically, structured]

**Static Duck Typing 🏗️**: A mix of duck and static typing, popularized by GO lang. Objects follow an interface (typing.Protocol, added in Python 3.8), but type checking happens before runtime.
[checks statically, nominal]




**INFIX operators power. Compound Interest Calculation in Python and Java**

**Python**
In Python, infix operators can be used with various types, including `decimal.Decimal`, ensuring precise calculations:

```python
from decimal import Decimal

principal = Decimal("1000")
rate = Decimal("0.05")
periods = 10

interest = principal * ((Decimal("1") + rate) ** periods - Decimal("1"))
print(interest)
```

**Java**
In Java, when using `BigDecimal` for precision, infix operators cannot be used. Instead, method chaining is required:

```java
import java.math.BigDecimal;

BigDecimal principal = new BigDecimal("1000");
BigDecimal rate = new BigDecimal("0.05");
int periods = 10;

BigDecimal interest = principal.multiply(BigDecimal.ONE.add(rate)
        .pow(periods).subtract(BigDecimal.ONE));

System.out.println(interest);
```


```python
s = 'ABC'
for char in s:
    print(char)
```

**For loop implemented with While**

```python
s = 'ABC'
it = iter(s)
while True:
    try:
        print(next(it))
    except StopIteration:
        del it
        break
```






## Notes
- **MRO** - **M**ethod **R**esolution **O**rder
    - CLASS.__mro__ or mro() returns order in which classes are inheriting their methods. Uses C3 algorithm to work (from first glance looks like BFS)
  
- **Deletion:**
  - **__del__** does not delete an object it deletes a reference. The object is deleted by the garbage collector when no more references are left
  - **weakref** is used to create references but don't increase the reference counter, so do not promise that the object will not be removed by gc
 
- **Annotation**
  - **compilers**: MyPy (strict), PyPy (has JIT that analyzes code and optimizes it by putting types), PyCharm's. Blue, Black and 8flake technologies used to follow all PEP standards
  - **validation** to validate a*b we have to know their type thus int*dict. The compiler does not multiply them it just checks that both types have the __mul__ method inside
  - **validation_types**: There are **DuckValidation** used in Python, JS, Dart and **Nominal** used in C++, Java and C#. Duck validation allows methods of child class to its parent validation. Nominal does not because it is checked once in creation.
  - **LSP** Barbara Liskov MIT prof. and nominate Turing laureate claimed that if P1 was inherited from P2 it cannot be used to type hint P2. But it can pass where P2 is expected
 
- **N + 1 problem**

Imagine simple classes
```python
class Author(models.Model):
    name = models.CharField(max_length=100)

class Book(models.Model):
    title = models.CharField(max_length=100)
    author = models.ForeignKey(Author, on_delete=models.CASCADE)
```
if we execute code like this
```python
books = Book.objects.all()
for book in books:
    print(book.title, book.author.name)
```
under the hood it will execute `SELECT * FROM book;` one time and `SELECT * FROM author WHERE id = <author_id>;` for each book so if there are 100 books it will be 1 + 100 queries to db
to fix this problem we can use select_related for ForeignKey relationship and prefetch_related for M2M
```python
books = Book.objects.select_related('author')
for book in books:
    print(book.title, book.author.name)
```
Django will execute one query with JOIN
```SQL
SELECT * FROM book
INNER JOIN author ON book.author_id = author.id;
```
or prefetch_related in this case
```python
authors = Author.objects.prefetch_related('book_set')
for author in authors:
    for book in author.book_set.all():
        print(author.name, book.title)
```
it will execute 2 queries one for the authors and another for books related to them
if this optimization is not enough we can always use annotate and values or write raw SQL

- **dict().keys()**
  
Memory Efficiency:

In **Python 2**, dict.keys() created a new list storing all keys.
In **Python 3**, dict.keys() returns a dynamic view that doesn’t copy the keys into a separate list. This saves memory, especially for large dictionaries.
Performance:

The new dict_keys object is lazy and reflects changes in the dictionary dynamically.
If you modify the dictionary, dict.keys() will update automatically without needing to create a new list.
Set-Like Behavior:


- **Exceptions**

```
BaseException
├── SystemExit
├── KeyboardInterrupt
├── GeneratorExit
└── Exception
    ├── ArithmeticError
    │   ├── FloatingPointError
    │   ├── OverflowError
    │   └── ZeroDivisionError
    ├── AssertionError
    ├── AttributeError
    ├── BufferError
    ├── EOFError
    ├── ImportError
    │   └── ModuleNotFoundError
    ├── LookupError
    │   ├── IndexError
    │   └── KeyError
    ├── MemoryError
    ├── NameError
    │   └── UnboundLocalError
    ├── OSError
    │   ├── BlockingIOError
    │   ├── ChildProcessError
    │   ├── ConnectionError
    │   │   ├── BrokenPipeError
    │   │   ├── ConnectionAbortedError
    │   │   ├── ConnectionRefusedError
    │   │   └── ConnectionResetError
    │   ├── FileExistsError
    │   ├── FileNotFoundError
    │   ├── InterruptedError
    │   ├── IsADirectoryError
    │   ├── NotADirectoryError
    │   ├── PermissionError
    │   ├── ProcessLookupError
    │   └── TimeoutError
    ├── ReferenceError
    ├── RuntimeError
    │   ├── NotImplementedError
    │   ├── RecursionError
    │   └── FileNotFoundError (alias)
    ├── StopAsyncIteration
    ├── StopIteration
    ├── SyntaxError
    │   └── IndentationError
    │       └── TabError
    ├── SystemError
    ├── TypeError
    ├── ValueError
    │   └── UnicodeError
    │       ├── UnicodeDecodeError
    │       ├── UnicodeEncodeError
    │       └── UnicodeTranslateError
    ├── Warning
        ├── DeprecationWarning
        ├── PendingDeprecationWarning
        ├── RuntimeWarning
        ├── SyntaxWarning
        ├── UserWarning
        ├── FutureWarning
        ├── ImportWarning
        ├── UnicodeWarning
        ├── BytesWarning
        └── ResourceWarning
```

**SOLID Principles in Python**

**S**ingle Responsibility Principle (SRP)
Each class should have only one reason to change.

*Bad Example:*

```python
class ReportManager:
    def generate(self, data):
        return f"Report: {data}"
    
    def save(self, report, filename):
        with open(filename, "w") as f:
            f.write(report)
```

*Why?* This class has two responsibilities: generating and saving reports.

*Good Example:*

```python
class ReportGenerator:
    def generate(self, data):
        return f"Report: {data}"

class ReportSaver:
    def save(self, report, filename):
        with open(filename, "w") as f:
            f.write(report)
```

*Why?* Each class now has a single responsibility.

**O**pen/Closed Principle (OCP)
Software entities should be open for extension but closed for modification.

*Bad Example:*

```python
class Discount:
    def apply(self, price, customer_type):
        if customer_type == "regular":
            return price * 0.9
        elif customer_type == "vip":
            return price * 0.8
```

*Why?* Adding new discount types requires modifying the class.

*Good Example:*

```python
from abc import ABC, abstractmethod

class Discount(ABC):
    @abstractmethod
    def apply(self, price):
        pass

class RegularDiscount(Discount):
    def apply(self, price):
        return price * 0.9

class VIPDiscount(Discount):
    def apply(self, price):
        return price * 0.8
```

*Why?* New discount types can be added without modifying existing code.

**L**iskov Substitution Principle (LSP)
Subtypes must be substitutable for their base types without altering program correctness.

*Bad Example:*

```python
class Bird:
    def fly(self):
        return "I can fly"

class Ostrich(Bird):
    def fly(self):
        return "I can't fly"
```

*Why?* Ostrich violates LSP because it changes the expected behavior.

*Good Example:*

```python
class Bird:
    pass

class FlyingBird(Bird):
    def fly(self):
        return "I can fly"

class Ostrich(Bird):
    pass
```

*Why?* The hierarchy now properly separates birds that can fly and those that cannot.

**I**nterface Segregation Principle (ISP)
Clients should not be forced to depend on interfaces they do not use.

*Bad Example:*

```python
class Machine:
    def print(self):
        pass
    
    def scan(self):
        pass
```

*Why?* A class that only prints still has to implement `scan`.

*Good Example:*

```python
from abc import ABC, abstractmethod

class Printer(ABC):
    @abstractmethod
    def print(self):
        pass

class Scanner(ABC):
    @abstractmethod
    def scan(self):
        pass

class MultifunctionPrinter(Printer, Scanner):
    def print(self):
        return "Printing"
    
    def scan(self):
        return "Scanning"
```

*Why?* Separate interfaces ensure classes only implement what they need.

**D**ependency Inversion Principle (DIP)
High-level modules should not depend on low-level modules. Both should depend on abstractions.

*Bad Example:*

```python
class MySQLDatabase:
    def connect(self):
        return "Connected to MySQL"

class Application:
    def __init__(self):
        self.db = MySQLDatabase()

    def start(self):
        return self.db.connect()
```

*Why?* The Application is tightly coupled to MySQLDatabase.

*Good Example:*

```python
from abc import ABC, abstractmethod

class Database(ABC):
    @abstractmethod
    def connect(self):
        pass

class MySQLDatabase(Database):
    def connect(self):
        return "Connected to MySQL"

class PostgreSQLDatabase(Database):
    def connect(self):
        return "Connected to PostgreSQL"

class Application:
    def __init__(self, db: Database):
        self.db = db

    def start(self):
        return self.db.connect()

# Injecting dependency
mysql_db = MySQLDatabase()
app = Application(mysql_db)
print(app.start())
```

*Why?* Application now depends on an abstraction, making it flexible and extensible.

These principles help write maintainable, scalable, and robust Python applications.

- **Class types**

  **Abstract Class**  
Used as a blueprint for other classes. It defines methods that must be implemented in subclasses.  

**Use case:** Enforce method implementation in subclasses.  

```python
from abc import ABC, abstractmethod

class Animal(ABC):
    @abstractmethod
    def make_sound(self):
        pass

class Dog(Animal):
    def make_sound(self):
        return "Bark!"

dog = Dog()
print(dog.make_sound())  # ✅ Bark!

# animal = Animal()  # ❌ TypeError: Can't instantiate abstract class
```

---

**Concrete Class**  
A regular class that can be instantiated directly.  

**Use case:** Standard class used in everyday OOP.

```python
class Car:
    def drive(self):
        print("Driving!")

car = Car()
car.drive()  # ✅ Driving!
```

---

**Mixin Class**  
Provides additional behavior but is not meant to be instantiated on its own.  

**Use case:** Code reusability without affecting the main inheritance hierarchy.  

```python
class LoggingMixin:
    def log(self, message):
        print(f"LOG: {message}")

class User(LoggingMixin):
    def __init__(self, name):
        self.name = name

user = User("Alice")
user.log("User logged in")  # ✅ LOG: User logged in
```

---

**Data Class**  
Simplifies object creation by automatically generating `__init__`, `__repr__`, and `__eq__`.  

**Use case:** Storing structured data efficiently.  

```python
from dataclasses import dataclass

@dataclass
class Point:
    x: int
    y: int

p1 = Point(1, 2)
p2 = Point(1, 2)
print(p1)          # ✅ Point(x=1, y=2)
print(p1 == p2)    # ✅ True (auto-generated __eq__)
```

---

**Singleton Class**  
Ensures only one instance of the class exists.  

**Use case:** Managing shared resources (e.g., database connections).  

```python
class Singleton:
    _instance = None

    def __new__(cls):
        if cls._instance is None:
            cls._instance = super().__new__(cls)
        return cls._instance

s1 = Singleton()
s2 = Singleton()
print(s1 is s2)  # ✅ True (same instance)
```

---

**Aggregate Class**  
Contains instances of other classes as attributes but does not control their lifecycle. Also, it is needed to import mixins in the correct order and does not have a body, so we don't care about the order of imports.  

**Use case:** Objects that reference other objects but do not "own" them.  

```python
class Engine:
    def start(self):
        print("Engine started!")

class Car:
    def __init__(self, engine: Engine):
        self.engine = engine

car_engine = Engine()
car = Car(car_engine)
car.engine.start()  # ✅ Engine started!
```

---

**Composition Class**  
Contains instances of other classes and controls their lifecycle.  

**Use case:** Stronger relationship than aggregation (objects are created inside the class).  

```python
class Battery:
    def charge(self):
        print("Battery charging!")

class ElectricCar:
    def __init__(self):
        self.battery = Battery()  # Created inside the class

car = ElectricCar()
car.battery.charge()  # ✅ Battery charging!
```

---

**Factory Class**  
Encapsulates object creation logic.  

**Use case:** Creating objects dynamically based on input.  

```python
class Car:
    def drive(self):
        print("Driving a car!")

class Truck:
    def drive(self):
        print("Driving a truck!")

class VehicleFactory:
    @staticmethod
    def get_vehicle(vehicle_type):
        if vehicle_type == "car":
            return Car()
        elif vehicle_type == "truck":
            return Truck()
        raise ValueError("Unknown vehicle type")

vehicle = VehicleFactory.get_vehicle("car")
vehicle.drive()  # ✅ Driving a car!
```

---

**Adapter Class**  
Acts as a bridge between incompatible interfaces.  

**Use case:** Making an existing class compatible with a new interface.  

```python
class OldPrinter:
    def print_text(self, text):
        print(f"Printing: {text}")

class NewPrinter:
    def print(self, text):
        print(f"New print: {text}")

class PrinterAdapter:
    def __init__(self, old_printer):
        self.old_printer = old_printer

    def print(self, text):
        self.old_printer.print_text(text)

old_printer = OldPrinter()
adapter = PrinterAdapter(old_printer)
adapter.print("Hello!")  # ✅ Printing: Hello!
```

---

**Proxy Class**  
Controls access to another object.  

**Use case:** Adding security, logging, or lazy initialization.  

```python
class RealSubject:
    def request(self):
        print("Processing request...")

class Proxy:
    def __init__(self, subject):
        self.subject = subject

    def request(self):
        print("Logging: Request is being made.")
        self.subject.request()

proxy = Proxy(RealSubject())
proxy.request()
# ✅ Logging: Request is being made.
# ✅ Processing request...
```

---

**Summary Table:**  
| Class Type   | Purpose |
|-------------|---------|
| **Abstract** | Enforces method implementation in subclasses |
| **Concrete** | Standard class that can be instantiated |
| **Mixin** | Adds behavior without affecting inheritance |
| **Data** | Auto-generates boilerplate code for structured data |
| **Singleton** | Ensures a single instance of a class |
| **Aggregate** | Has objects as attributes but doesn’t own them; helps with correct mixin import order |
| **Composition** | Owns and manages objects as attributes |
| **Factory** | Creates objects dynamically based on input |
| **Adapter** | Bridges incompatible interfaces |
| **Proxy** | Controls access to another object |




- **Overloading**

  How @overload Works:
  
 1. You write multiple @overload-decorated function signatures.
 2. You then implement a single function without @overload.
 3. The actual function handles all cases dynamically.

Example:

```python
from typing import overload, Union

@overload
def process(value: int) -> str: ...
    
@overload
def process(value: str) -> int: ...

def process(value: Union[int, str]) -> Union[str, int]:
    if isinstance(value, int):
        return str(value)  # Convert int to string
    elif isinstance(value, str):
        return len(value)  # Return length of string
    raise ValueError("Unsupported type")

# Usage:
print(process(10))    # "10" (str)
print(process("abc")) # 3 (int)
```


- **Operator Overloading Rules in Python**

It is forbidden to overload operators for built-in types.

New operators cannot be created; only existing ones can be overloaded.

Some operators cannot be overloaded at all: **is, and, or, not** (this does not apply to bitwise operators &, |, ~).


**Table 13.1. Method Names for Infix Operators**

| Operator | Direct | Inverse | In-Place | Description |
|----------|--------|---------|----------|-------------|
| `+` | `__add__` | `__radd__` | `__iadd__` | Addition or concatenation |
| `-` | `__sub__` | `__rsub__` | `__isub__` | Subtraction |
| `*` | `__mul__` | `__rmul__` | `__imul__` | Multiplication or repetition |
| `/` | `__truediv__` | `__rtruediv__` | `__itruediv__` | True division |
| `//` | `__floordiv__` | `__rfloordiv__` | `__ifloordiv__` | Floor division |
| `%` | `__mod__` | `__rmod__` | `__imod__` | Modulo division |
| `divmod()` | `__divmod__` | `__rdivmod__` | `__idivmod__` | Returns a tuple (quotient, remainder) |
| `**`, `pow()` | `__pow__` | `__rpow__` | `__ipow__` | Exponentiation (supports modulo argument) |
| `@` | `__matmul__` | `__rmatmul__` | `__imatmul__` | Matrix multiplication |
| `&` | `__and__` | `__rand__` | `__iand__` | Bitwise AND |
| `|` | `__or__` | `__ror__` | `__ior__` | Bitwise OR |
| `^` | `__xor__` | `__rxor__` | `__ixor__` | Bitwise XOR |
| `<<` | `__lshift__` | `__rlshift__` | `__ilshift__` | Left bitwise shift |
| `>>` | `__rshift__` | `__rrshift__` | `__irshift__` | Right bitwise shift |

---

**Table 16.2. Comparison Operators: Inverse Methods Are Called When the First Call Returns `NotImplemented`**

| Group | Infix Operator | Direct Method Call | Inverse Method Call | Fallback Behavior |
|--------|---------------|--------------------|---------------------|--------------------|
| Equality | `a == b` | `a.__eq__(b)` | `b.__eq__(a)` | Return `id(a) == id(b)` |
| | `a != b` | `a.__ne__(b)` | `b.__ne__(a)` | Return `not (a == b)` |
| Ordering | `a > b` | `a.__gt__(b)` | `b.__lt__(a)` | Raise `TypeError` |
| | `a < b` | `a.__lt__(b)` | `b.__gt__(a)` | Raise `TypeError` |
| | `a >= b` | `a.__ge__(b)` | `b.__le__(a)` | Raise `TypeError` |
| | `a <= b` | `a.__le__(b)` | `b.__ge__(a)` | Raise `TypeError` |




**How does Python store `int`?**

In Python, `int` is not stored as a fixed number of bits but as a list of fixed-length blocks (`digits`). This is implemented through arbitrary-precision arithmetic.

- In a **32-bit system**, Python uses **30-bit blocks** (essentially splitting large numbers into 30-bit chunks).
- In a **64-bit system**, Python uses **60-bit blocks**.

**Example:** The number `2 ** 1000` in Python is **not stored as a 1000-bit number**. Instead, it is broken into multiple 30-bit or 60-bit blocks, and operations are performed on these blocks.


