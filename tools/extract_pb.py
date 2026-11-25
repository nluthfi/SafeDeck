import urllib.request

req = urllib.request.Request('https://www.pointblank.id/favicon.ico', headers={'User-Agent': 'Mozilla/5.0'})
data = urllib.request.urlopen(req, timeout=10).read()

png_start = data.find(b'\x89PNG\r\n\x1a\n')
print('PNG start:', png_start)

# Find last IEND in data or parse chunks
iend_magic = b'IEND\xaeB`\x82'
pos = data.find(iend_magic, png_start)
if pos != -1:
    png_bytes = data[png_start:pos + len(iend_magic)]
    with open('assets/icons/services/point_blank.png', 'wb') as f:
        f.write(png_bytes)
    print('Successfully extracted point_blank.png, size:', len(png_bytes))
else:
    # ICO parsing
    import struct
    # read directory
    count = struct.unpack('<H', data[4:6])[0]
    print('ICO image count:', count)
    best_size = 0
    best_data = None
    for i in range(count):
        offset_entry = 6 + i * 16
        w, h, _, _, _, _, size, offset = struct.unpack('<BBBBHHII', data[offset_entry:offset_entry+16])
        img_data = data[offset:offset+size]
        if img_data.startswith(b'\x89PNG'):
            if size > best_size:
                best_size = size
                best_data = img_data
    if best_data:
        with open('assets/icons/services/point_blank.png', 'wb') as f:
            f.write(best_data)
        print('Saved best PNG from ICO, size:', len(best_data))
