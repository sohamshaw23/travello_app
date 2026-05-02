import time
from collections.abc import Hashable


class TTLCache:
    def __init__(self, ttl_seconds: int = 600) -> None:
        self.ttl_seconds = ttl_seconds
        self._store: dict[Hashable, tuple[float, object]] = {}

    def get(self, key: Hashable) -> object | None:
        entry = self._store.get(key)
        if entry is None:
            return None

        expires_at, value = entry
        if expires_at < time.time():
            self._store.pop(key, None)
            return None
        return value

    def set(self, key: Hashable, value: object) -> None:
        self._store[key] = (time.time() + self.ttl_seconds, value)
