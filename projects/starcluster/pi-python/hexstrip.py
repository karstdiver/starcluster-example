input_filename  = "pi1.sh"
output_filename = "pi.sh"
with open(input_filename,'rb') as ifile:
    with open(output_filename, 'wb') as ofile:
        data = ifile.read(1)
        while data:
            if data == '\x80': data = ' '
            if data != '\xe2' and \
               data != '\x80' and \
               data != '\x80' and \
               data != '\xcf':
               print ("%s", data)
               ofile.write(data)
            data = ifile.read(1)
