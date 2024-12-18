# simple python implementation of murmurhash

    
def xencode(x):
    if isinstance(x, bytes) or isinstance(x, bytearray):
       return x
    else:
        return x.encode()

def murmurhash(data, seed = 111):
    # set constant 1 and constant 2
    c1 = 0xcc9e2d51
    c2 = 0x1b873593
    
    h1 = seed
    
    key = bytearray(xencode(data))
    
    length = len(data)
    nb_blocks = int(length/4)
    
    for block_start in range(0,nb_blocks*4,4):
        
        # big endian
        
        k1 = key[ block_start + 3 ] << 24 | \
             key[ block_start + 2 ] << 16 | \
             key[ block_start + 1 ] <<  8 | \
             key[ block_start + 0 ]
        

        k1 = ( c1 * k1 ) & 0xFFFFFFFF
        # left rotate by combining left shift and right shift
        k1 = ( k1 << 15 | k1 >> 17 ) & 0xFFFFFFFF # inlined ROTL32

        k1 = ( c2 * k1 ) & 0xFFFFFFFF
        
        # xor combining h1 and k1
        h1 ^= k1
        
        h1  = ( h1 << 13 | h1 >> 19 ) & 0xFFFFFFFF # inlined ROTL32
        
        h1  = ( h1 * 5 + 0xe6546b64 ) & 0xFFFFFFFF
        
    # dealing with the tail
    
    tail_index = nb_blocks * 4
    
    k1 = 0
    # bitwise AND operator to calculate the number of leftover bytes
    tail_size = length & 3
    
    if tail_size >= 3:
        k1 ^= key[tail_index + 2] << 16
    if tail_size >= 2:
        k1 ^= key[tail_index + 1] << 8
    if tail_size >= 1:
        k1 ^= key[tail_index + 0]
        
    k1 = (k1 * c1) & 0xFFFFFFFF
    k1 = (k1 << 15 | k1 >> 17) & 0xFFFFFFFF
    k1 = (k1 * c2) & 0xFFFFFFFF
    h1 ^= k1

    def finalize(h):
        h ^= h >> 16
        h = (h * 0x85ebca6b) & 0xFFFFFFFF
        h ^= h >> 13
        h = (h * 0xc2b2ae35) & 0xFFFFFFFF
        h ^= h >> 16
        return h
    
    unsigned_val = finalize( h1 ^ length )
    print(unsigned_val)
    
    if unsigned_val & 0x80000000 == 0:
        return unsigned_val
    else:
        return -((unsigned_val ^ 0xFFFFFFFF) + 1)
    

print(murmurhash('agtcactggt'))