class Iterable:
    def __init__(self, *args):
        self.args = args
        self.index = 0

    def __iter__(self):
        return self  # ❌ Not recommended if you want multiple iterations on the same object

    def __next__(self):
        if self.index >= len(self.args):
            raise StopIteration
        result = self.args[self.index]
        self.index += 1
        return result


class Iterator:
    def __init__(self, *args):
        self.args = args

    def __iter__(self):
        return Iterable(*self.args)  # ✅ Returns a new iterable each time


a = Iterator(1, 2, 3)  # Try to Put here Iterable instead of Iterator
it = iter(a)

print(next(it))
print(next(it))

b = iter(a)  # Fresh iterator, if u use self it would be old one
print(next(b))
print(next(it))




# ASYNC
print('\n\nASYNC\n\n')

import asyncio

class AsyncCounter:
    def __init__(self, start, stop):
        self.current = start
        self.stop = stop

    def __aiter__(self):
        return self  # ✅ Async iterators usually return self

    async def __anext__(self):
        if self.current >= self.stop:
            raise StopAsyncIteration  # ✅ Proper way to stop an async iterator
        self.current += 1
        await asyncio.sleep(1)  # Simulating async operation (e.g., network call)
        return self.current

async def main():
    async for num in AsyncCounter(0, 5):
        print(num)

asyncio.run(main())  # Runs the async loop
