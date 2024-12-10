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
