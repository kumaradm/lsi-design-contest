def float_to_fp(num,integer_precision,fraction_precision):   
    if(num<0):
        sign_bit = 1                                          #sign bit is 1 for negative numbers in 2's complement representation
        num = -1*num
    else:
        sign_bit = 0
    precision = '0'+ str(integer_precision) + 'b'
    integral_part = format(int(num),precision)
    fractional_part_f = num - int(num)
    fractional_part = []
    for i in range(fraction_precision):
        d = fractional_part_f*2
        fractional_part_f = d -int(d)        
        fractional_part.append(int(d))
    fraction_string = ''.join(str(e) for e in fractional_part)
    if(sign_bit == 1):
        binary = str(sign_bit) + twos_comp(integral_part + fraction_string,integer_precision,fraction_precision)
    else:
        binary = str(sign_bit) + integral_part+fraction_string
    return str(binary)

def twos_comp(val,integer_precision,fraction_precision):
    flipped = ''.join(str(1-int(x))for x in val)
    length = '0' + str(integer_precision+fraction_precision) + 'b'
    bin_literal = format((int(flipped,2)+1),length)
    return bin_literal

def fp_to_float(s,integer_precision,fraction_precision):       #s = input binary string
    number = 0.0
    i = integer_precision - 1
    j = 0
    if(s[0] == '1'):
        s_complemented = twos_comp((s[1:]),integer_precision,fraction_precision)
    else:
        s_complemented = s[1:]
    while(j != integer_precision + fraction_precision -1):
        number += int(s_complemented[j])*(2**i)
        i -= 1
        j += 1
    if(s[0] == '1'):
        return (-1)*number
    else:
        return number

# abscissas = [-6, -3,  0,  3,  6]
# slopes = [0.014984416673644002, 0.1508580422741444, 0.15085804227414445, 0.014984416673643993]
# intercept = [0.09237912319849878, 0.5, 0.5, 0.9076208768015014]

# abscissas = [-6, -4.5, -3, -1.5, 0, 1.5, 3, 4.5, 6]
# slopes = [0.005676212982638936, 0.024292620364649065, 0.08999976708585972, 0.2117163174624291, 0.2117163174624291, 0.08999976708585981, 0.024292620364648965, 0.005676212982639021]
# intercept = [0.036529901052468394, 0.12030373427151397, 0.31742517443514595, 0.5, 0.5, 0.6825748255648539, 0.8796962657284865, 0.9634700989475312]

# abscissas_fixed = [float_to_fp(x, 3, 12) for x in abscissas]
# slopes_fixed = [float_to_fp(x, 3, 12) for x in slopes]
# intercept_fixed = [float_to_fp(x, 3, 12) for x in intercept]

# abscissas_float = [fp_to_float(x, 3, 12) for x in abscissas_fixed]
# slopes_float = [fp_to_float(x, 3, 12) for x in slopes_fixed]
# intercept_float = [fp_to_float(x, 3, 12) for x in intercept_fixed]

# print(f'abscissas: {abscissas}')
# print(f'slopes: {slopes}')
# print(f'intercept: {intercept}')

# print(f'abscissas fixed: {abscissas_fixed}')
# print(f'slopes fixed: {slopes_fixed}')
# print(f'intercept fixed: {intercept_fixed}')

# print(f'abscissas: {abscissas_float}')
# print(f'slopes: {slopes_float}')
# print(f'intercept: {intercept_float}')

# slope = ['0000000000000000', '0000000000111101', '0000001001101001', '0000001001101001', '0000000000111101']
# intersect = ['0000000000000000', '0000000101111010', '0000100000000000', '0000100000000000', '0000111010000101']
# res_mult = ['1000000000000000', '1111111101001001', '0000000000000000', '0000011100111011', '0000000101101110']
# out = ['0000000000000000', '0000000011000011', '0000100000000000', '0000111100111011', '0000111111110011']
# slope_float = [fp_to_float(x, 3, 12) for x in slope]
# intersect_float = [fp_to_float(x, 3, 12) for x in intersect]
# res_mult_float = [fp_to_float(x, 3, 12) for x in res_mult]
# out_float = [fp_to_float(x, 3, 12) for x in out]
# print(f"slope: {slope_float}")
# print(f"intersect: {intersect_float}")
# print(f"res_mult: {res_mult_float}")
# print(f"out: {out_float}")

# slope = ['0000000000000000', '0000000000111101', '0000001001101001', '0000001001101001', '0000000000111101']
# intersect = ['0000000000000000', '0000000101111010', '0000100000000000', '0000100000000000', '0000111010000101']
# res_mult = ['1000000000000000', '1111111101001001', '0000000000000000', '0000011100111011', '0000000101101110']
# out = ['0000000000000000', '0000000000101110', '0000000011000011', '0000001011101100', '0000100000000000', '0000110100010100', '0000111100111011', '0000111111010000', '0000111111110100']
# slope_float = [fp_to_float(x, 3, 12) for x in slope]
# intersect_float = [fp_to_float(x, 3, 12) for x in intersect]
# res_mult_float = [fp_to_float(x, 3, 12) for x in res_mult]
# out_float = [fp_to_float(x, 3, 12) for x in out]
# print(f"slope: {slope_float}")
# print(f"intersect: {intersect_float}")
# print(f"res_mult: {res_mult_float}")
# print(f"out: {out_float}")

# test = -100
# test_fixed = float_to_fp(test, 3, 12)
# test_float = fp_to_float(test_fixed, 3, 12)
# print(test_float)

# absis = ['1101000000000000', '1101100000000000', '1110000000000000', '1110100000000000', '1111000000000000', '1111100000000000', '0000000000000000', '0000100000000000', '0001000000000000', '0001100000000000', '0010000000000000', '0010100000000000', '0011000000000000']
# ordinate = ['0000000000000011', '0000000000001111', '0000000000110001', '0000000001100010', '0000000001001110', '0000001011101101', '0000010110001100', '0000101011101101', '0001000100110011', '0001100001100100', '0010000000011011', '0010100000001111', '0011000000000011']
# absis_float = [fp_to_float(x, 3, 12) for x in absis]
# ordinate_float = [fp_to_float(x, 3, 12) for x in ordinate]
# print(absis_float)
# print(ordinate_float)

abcissas = [-6.0, -4.5, -3.0, -1.5, 0.0, 1.5, 3.0, 4.5, 6.0]
slopes = [0.005714706473908947, 0.02502640448343212, 0.10188395093934033, 0.32782260171812855, 0.6721773982818714, 0.8981160490606598, 0.9749735955165679, 0.9942852935260907]
intercepts = [0.03676392398118404, 0.12366656502403832, 0.35423920439176293, 0.6931471805599453, 0.6931471805599453, 0.3542392043917628, 0.12366656502403828, 0.03676392398118544]

print("abcissas")
for i in range(len(abcissas)):
    print(float_to_fp(abcissas[i], 3, 12))

print("\nslopes")
for i in range(len(slopes)):
    print(float_to_fp(slopes[i], 3, 12))

print("\nintercepts")
for i in range(len(intercepts)):
    print(float_to_fp(intercepts[i], 3, 12))

out = ['0000000000000000',
'0000000000101110',
'0000000011000011',
'0000001011101100',
'0000100000000000',
'0000110100010100',
'0000111100111011',
'0000111111010000',
'0000111111110100']

print('\noutput:')
for i in range(len(out)):
    print(fp_to_float(out[i], 3, 12))