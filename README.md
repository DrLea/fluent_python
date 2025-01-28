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






## Notes
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
