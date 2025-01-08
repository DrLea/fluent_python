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
- 


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
