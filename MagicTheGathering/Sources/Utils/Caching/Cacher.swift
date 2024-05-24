
import Foundation

actor Cacher<Key: Hashable, Value>  {

    private var cache = NSCache<WrappedKey, Entry>()

    func getValue(for key: Key) -> Value? {
        return cache.object(forKey: WrappedKey(key))?.value
    }

    func save(_ value: Value, for key: Key) {
        cache.setObject(Entry(value), forKey: WrappedKey(key))
    }

    func removeValue(forKey key: Key) {
        cache.removeObject(forKey: WrappedKey(key))
    }

    private class WrappedKey: NSObject {

        let key: Key

        init(_ key: Key) {
            self.key = key
        }

        override var hash: Int {
            return key.hashValue
        }

        override func isEqual(_ object: Any?) -> Bool {
            guard let other = object as? WrappedKey else { return false }
            return other.key == key
        }
    }

    private class Entry {
        let value: Value

        init(_ value: Value) {
            self.value = value
        }
    }
}
