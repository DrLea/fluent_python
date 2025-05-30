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
 

## Chapter 19: Concurrency

**Concurrency**  
Ability to handle multiple tasks by switching between them or running them in parallel when possible. A single-core processor allows concurrency via an OS scheduler that alternates task execution. Also known as multitasking.  

**Parallelism**  
Executing multiple computations simultaneously using multi-core processors, multiple CPUs, GPUs, or distributed systems.  

**Execution Unit**  
An entity that runs code concurrently with independent state and call stack. Python supports three types: processes, threads, and coroutines.  

**Process**  
An instance of a program during execution with allocated memory and CPU time. Processes are isolated, communicate via IPC (e.g., pipes, sockets), and require serialization for Python object transfer. Processes support preemptive multitasking. **sys.cpu_count()** is a helpful func that returns the number of cores in our machine, on Intel proc it shows more than actual number because it counts hyper-threads as well.

**Thread**  
An execution unit within a process. Threads share memory, enabling data sharing but risking race conditions. Threads consume fewer resources than processes and support preemptive multitasking.  

**Coroutine**  
A function that can pause and resume execution. In Python, coroutines use `async def`, `yield`, or `await` and run within an event loop. They support cooperative multitasking and are resource-efficient compared to threads and processes.  

**Queue**  
A FIFO data structure enabling execution units to exchange data and control messages. Python provides `queue` (for threads), `multiprocessing.Queue` (for processes), and `asyncio.Queue` (for async tasks). Supports LIFO and priority queues.  

**Lock**  
A synchronization mechanism to prevent data corruption. Execution units must acquire a lock before modifying shared data. A basic lock is a mutex (mutual exclusion). Implementations vary by concurrency model.  

**Race Condition**  
A conflict over a shared resource. Occurs when multiple execution units access a shared resource simultaneously, leading to unpredictable behavior. Can also happen with CPU time allocation.


- **Processes, Threads, and GIL in Python**

- Each Python interpreter instance is a separate process.  
- Additional processes can be created using `multiprocessing` or `concurrent.futures`.  
- The `subprocess` module runs external programs.  

**Threads in Python**  
- Python runs user code and garbage collection in a single thread.  
- Additional threads can be created with `threading` or `concurrent.futures`.  

**Global Interpreter Lock (GIL)**  
- GIL ensures only one thread executes Python code at a time.  
- It is periodically released (~every 5ms) to allow thread switching.  
- C extensions can release GIL for long tasks.  
- I/O operations (disk, network, `time.sleep()`) release GIL automatically.  

**Impact of GIL**  
- GIL limits performance for CPU-bound tasks but has little effect on I/O-bound tasks.  
- Use `multiprocessing` or `ProcessPoolExecutor` to utilize multiple CPU cores.  
- Jython and IronPython have no GIL but are outdated.  
- PyPy has GIL but provides better performance in some cases.  

**Async Programming**  
- `asyncio` runs in a single thread and is unaffected by GIL.  
- Additional threads in async apps should be used only for specific tasks.


**Greenlet and Gevent: Lightweight Concurrency in Python**

**Greenlet**
`greenlet` is a Python library that provides lightweight coroutines (also called "micro-threads"). Unlike normal threads, greenlets are **cooperatively scheduled**, meaning they **do not rely on the OS scheduler** and instead manually yield control.

**Key Features:**
- Extremely lightweight compared to OS threads.
- No Global Interpreter Lock (GIL) issues, as switching happens within a single thread.
- No true parallelism, just concurrency through context switching.

**Example Using Greenlet:**
```python
from greenlet import greenlet

def task1():
    print("Task 1: Start")
    gr2.switch()
    print("Task 1: Resume")

def task2():
    print("Task 2: Start")
    gr1.switch()
    print("Task 2: Resume")

gr1 = greenlet(task1)
gr2 = greenlet(task2)
gr1.switch()
```

**Gevent**
`gevent` is a high-level library built on top of `greenlet` that automates coroutine switching. It replaces common **blocking** functions (like `time.sleep()`, `socket.recv()`, etc.) with **non-blocking** versions using monkey patching.

**Key Features:**
- Automatic coroutine switching (no need for manual `.switch()`).
- Supports networking, web scraping, and I/O-heavy tasks efficiently.
- Monkey patches Python’s standard library to make blocking calls non-blocking.

**Example Using Gevent:**
```python
import gevent
from gevent import monkey

monkey.patch_all()

def task(name, delay):
    for i in range(3):
        print(f'{name} iteration {i}')
        gevent.sleep(delay)

g1 = gevent.spawn(task, "Task 1", 1)
g2 = gevent.spawn(task, "Task 2", 1.5)

gevent.joinall([g1, g2])
```

**Comparison: Greenlet vs Gevent vs Asyncio vs Threads**
| Feature         | **Greenlet** | **Gevent** | **Asyncio** | **Threading** |
|---------------|------------|---------|---------|------------|
| **Type** | Manual coroutines | Automatic coroutines | Async event loop | OS threads |
| **Switching** | Manual (`switch()`) | Automatic (`spawn()`) | Automatic (`await`) | Preemptive (OS) |
| **Parallelism?** | ❌ No | ❌ No | ❌ No | ❌ No (due to GIL) |
| **Best For** | Fine-grained control | Networking, I/O | Async libraries | Blocking I/O |



## Chapter 24 Metaprogramming

It is difficult to state where it is really needed to create classes on run unless you are not writing new framework.

We used to think that type() is just method that checks type of obj but in fact it is meta class that can create classes if you call it with 3 params 

type(name, (tuple of parent classes if no then object,), {dict of methods and attrs}) -> class

NamedTuple can also be used to create simple classes as data storages yet in most trivial cases, but it is not the same



 
## Raw book parts
- According to PEP 484, int is compatible with float, and float is compatible with complex. In practice, this makes sense because int supports all the operations float does, plus additional ones like &, |, <<, etc. As a result, int is also compatible with complex. For example, if i = 3, then i.real is 3 and i.imag is 0.
But it does not work with typing because float does not inheriate from int and vice versa
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


- **For loop implemented with While**

```python
s = 'ABC'
for char in s:
    print(char)
```


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



- **REPL** - (read-eval-print-loop)

Works as a heart of Interpreters


- **EAFP**  
Easier to ask for forgiveness than permission. This Python programming style means it's better to assume that a key or attribute exists and catch an exception if it doesn't. This approach results in frequent use of `try` and `except` blocks, making the code cleaner and often more efficient. It contrasts with the **LBYL** style, common in languages like C.

- **LBYL**  
Look before you leap. This style involves checking preconditions before accessing or calling something. It is opposite to **EAFP** and often relies on many `if` statements. In multithreaded programs, it can lead to race conditions, such as:
```python
if key in mapping:
    return mapping[key]  # Another thread may remove the key before this line
```
This issue can be mitigated with locking or by using the **EAFP** approach.

---

- **Do This, Then That: Else Blocks Outside If**  
The `else` clause is not limited to `if` statements—it can also be used with `for`, `while`, and `try`. However, its semantics differ significantly from `if/else`:
- **for/else**: Executes if the loop completes normally (not interrupted by `break`).
- **while/else**: Executes if the loop exits due to the condition becoming false (not `break`).
- **try/else**: Executes only if no exception occurs in `try`.

According to Python’s documentation, exceptions raised in `else` are not caught by preceding `except` blocks. Some argue that `else` is misleading in loops, as it implies "otherwise" instead of "then." A more intuitive keyword might have been `then`, but changing Python syntax would be complex.

---

- **Unicode Trivia: λ**  
The official Unicode name for `λ` (U+03BB) is **GREEK SMALL LETTER LAMDA**—without the "b." This spelling follows a request from Greece’s national body, as documented by the Unicode Consortium.




- **vars(obj)** -> dict is a built-in Python function that returns the __ dict __ attribute of an object.
``` python
class Person:
    def __init__(self, name, age):
        self.name = name
        self.age = age

p = Person("Alice", 25)
print(vars(p))
# {'name': 'Alice', 'age': 25}

import math
a = {'+': lambda a,b: a+b}
a.extend(vars(math))
```
If the object has no __ dict __ attribute (e.g., if it's a built-in type like int, list, or a class using __ slots __), vars(obj) will raise a TypeError.
vars() without arguments returns the dictionary of the current local scope, similar to locals().


- **WSGI**
![image](https://github.com/user-attachments/assets/a4e3aae1-bba7-4552-9938-c37d1d9f61d3)

**Gunicorn**  
- **Strengths:** Simple, easy to configure, works well with Django & Flask, good for synchronous workloads.  
- **When to Choose:** If you need a reliable WSGI server with minimal setup and are okay with a prefork model (no native async support).  

**uWSGI**  
- **Strengths:** Highly configurable, supports multiple worker models (prefork, threaded, async), good for performance tuning.  
- **When to Choose:** If you need fine-grained control over concurrency, high performance, or compatibility with large-scale applications.  

**NGINX Unit**  
- **Strengths:** Dynamic configuration (no restarts needed), supports multiple languages (Python, PHP, Go, etc.), lightweight and modern.  
- **When to Choose:** If you need a versatile application server that can run different languages with minimal configuration overhead.  

**mod_wsgi**  
- **Strengths:** Integrated with Apache, stable, good for hosting multiple Python apps in shared environments.  
- **When to Choose:** If you're already using Apache and want a tightly integrated solution without extra reverse proxies.


___

- **Async**
  ![image](https://github.com/user-attachments/assets/d4293877-0810-498c-80e3-a4e3d0931ccb)


**Under the Hood of the Asyncio Event Loop**

The asyncio event loop uses `.send` to activate coroutines. Coroutines, in turn, call other coroutines, including library functions, using `await`. As mentioned earlier, `await` borrows much of its implementation from `yield from`, which also utilizes `.send` for coroutine management.

The `await` chain eventually reaches a low-level awaitable object that returns a generator. The event loop interacts with this generator in response to events such as timer triggers or network I/O. These low-level awaitable objects and generators reside deep within libraries and are not part of their public APIs. Some may even be written in C as extensions.

By using functions like `asyncio.gather` and `asyncio.create_task`, we can create multiple concurrent `await` channels, enabling concurrent execution of I/O operations within a single event loop in a single thread.


 - **Parenthises**

Sometimes we need to put () because . (dot) has higher priority than await

```{name for name in names if (await probe(name)).found}```


- **Semaphores in Python**

Edsger Dijkstra invented semaphores in the early 1960s. They are flexible synchronization primitives used to control access to shared resources. Python provides three semaphore implementations: in the `threading`, `multiprocessing`, and `asyncio` modules.

**Threading Semaphore**
```python
import threading
import time

semaphore = threading.Semaphore(2)

def task(name):
    with semaphore:  # Acquires and releases automatically
        print(f"{name} is running")
        time.sleep(2)
    print(f"{name} finished")

threads = [threading.Thread(target=task, args=(f"Thread-{i}",)) for i in range(5)]

for t in threads:
    t.start()
for t in threads:
    t.join()
```

**Multiprocessing Semaphore**
```python
import multiprocessing
import time

def worker(semaphore, name):
    with semaphore:  # Acquires and releases automatically
        print(f"{name} is running")
        time.sleep(2)
    print(f"{name} finished")

if __name__ == "__main__":
    semaphore = multiprocessing.Semaphore(2)
    processes = [multiprocessing.Process(target=worker, args=(semaphore, f"Process-{i}")) for i in range(5)]
    
    for p in processes:
        p.start()
    for p in processes:
        p.join()
```

**Asyncio Semaphore**
```python
import asyncio

async def task(semaphore, name):
    async with semaphore:  # Acquires and releases automatically
        print(f"{name} is running")
        await asyncio.sleep(2)
    print(f"{name} finished")

async def main():
    semaphore = asyncio.Semaphore(2)
    tasks = [task(semaphore, f"Task-{i}") for i in range(5)]
    await asyncio.gather(*tasks)

asyncio.run(main())
```

**BoundedSemaphore**
Each module provides `BoundedSemaphore`, which prevents the semaphore count from exceeding the initial value. This ensures that `release()` is not called more times than `acquire()`, avoiding logical errors in resource management.



- **Device Latency Comparison**

| Device          | CPU Cycles | "Human" Scale |
|----------------|------------|---------------|
| L1 Cache      | 3          | 3 seconds     |
| L2 Cache      | 14         | 14 seconds    |
| RAM (Main Memory) | 250    | 250 seconds   |
| Disk    | 41,000,000  | 1.3 years     |
| Network    | 240,000,000 | 7.6 years     |

Ryan Dahl (Node.js creator) claims that we should not treat file or network IO operations as nonblocking. Because of this table



- **Special Methods in Python**

In Python, special methods (also known as dunder methods) are always looked up in the class rather than the instance. This means that even if an instance has an attribute with the same name as a special method, the method in the class will not be overridden.


```python
class Example:
    def __len__(self):
        return 42

instance = Example()
print(len(instance))  # Output: 42

# Attempting to override __len__ at the instance level
instance.__len__ = lambda: 100
print(len(instance))  # Still outputs: 42
```


- **Practical Tips for Using Descriptors**

**Use `property` for Simplicity**  
The built-in `property` class creates overriding descriptors with both `__get__` and `__set__` methods. If a setter is not provided, it raises `AttributeError`, making it an easy way to create read-only attributes.

**Read-Only Descriptors Require `__set__`**  
If implementing a read-only attribute with a descriptor, define both `__get__` and `__set__`. The `__set__` method should raise `AttributeError` to prevent modification.

**Validation Descriptors Need Only `__set__`**  
For value-checking descriptors, implement `__set__` to validate input and store the value in the instance's `__dict__`. This avoids calling `__get__` and improves performance.

**Efficient Caching with `__get__` Only**  
A descriptor with only `__get__` is non-overriding. It can perform expensive computations and cache the result in an instance attribute, bypassing `__get__` on subsequent access. The `@functools.cached_property` decorator works this way.

**Instance Attributes Can Mask Non-Special Methods**  
Functions and methods define only `__get__`, so assigning `my_obj.the_method = 7` masks the method for that instance. However, special methods like `__repr__` are always looked up in the class, not instances.



**The Mysterious Relationship Between `object` and `type`**

![image](https://github.com/user-attachments/assets/e4e742e2-2fa9-466f-8016-dca65cbdd9d9)


There is an astonishing relationship between the `object` and `type` classes:

- `object` is an instance of `type`, while
- `type` is a subclass of `object`.

This relationship is "magical": it cannot be fully expressed using Python's own means because each of these classes must exist before the other can be defined. Moreover, the fact that `type` is an instance of itself is also a kind of magic.


![image](https://github.com/user-attachments/assets/b7aff003-50ab-4e93-b21f-8639f806df29)










___




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




- **How does Python store `int`?**

In Python, `int` is not stored as a fixed number of bits but as a list of fixed-length blocks (`digits`). This is implemented through arbitrary-precision arithmetic.

- In a **32-bit system**, Python uses **30-bit blocks** (essentially splitting large numbers into 30-bit chunks).
- In a **64-bit system**, Python uses **60-bit blocks**.

**Example:** The number `2 ** 1000` in Python is **not stored as a 1000-bit number**. Instead, it is broken into multiple 30-bit or 60-bit blocks, and operations are performed on these blocks.


- **🔹 Attributes in all objects**  

**`__class__`** → The object's class  
**`__dir__()`** → Lists all available attributes  
**`__repr__`, `__str__`** → String representations  
**`__eq__`, `__ne__`, `__lt__`, `__le__`, `__gt__`, `__ge__`** → Comparison methods  
**`__hash__`** → Unique identifier (for hashable objects)  
**`__sizeof__()`** → Memory size of the object  

**🔸 Type-dependent attributes**  

**`__dict__`** → Only for objects with dynamic attributes  (noo 😿)
**`__name__`** → Only for functions, classes, and modules  (noo 😿)
**`__getitem__`, `__setitem__`** → Only for indexable objects  
**`__call__`** → Only for callable objects  


**Descriptor**

A **descriptor** is an object that defines how an attribute is accessed, modified, or deleted in another class. It is implemented using methods like `__get__`, `__set__`, and `__delete__` inside a class. Descriptors are typically used to manage attribute access in a controlled way, such as for validation, logging, or computed properties.

**Example:**

```python
class Descriptor:
    def __init__(self, name):
        self.name = name

    def __get__(self, instance, owner):
        print(f"Getting {self.name}")
        return instance.__dict__.get(self.name)
    
    def __set__(self, instance, value):
        print(f"Setting {self.name} to {value}")
        instance.__dict__[self.name] = value
    
    def __delete__(self, instance):
        print(f"Deleting {self.name}")
        del instance.__dict__[self.name]

class MyClass:
    attr = Descriptor("attr")

obj = MyClass()
obj.attr = 42  # Setting attr to 42
print(obj.attr)  # Getting attr, prints 42
del obj.attr  # Deleting attr
```




