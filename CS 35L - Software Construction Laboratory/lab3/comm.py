#!/usr/bin/python
'''
Wenlong Xiong
204407085
Lab 3
'''

import locale, string, sys
from optparse import OptionParser

class comm:
    def __init__(self, f_name_1, f_name_2, options):
        self.opts = options
        f1 = open(f_name_1, 'r')
        self.lines1 = f1.readlines()
        f1.close()
        f2 = open(f_name_2, 'r')
        self.lines2 = f2.readlines()
        f2.close()
        
        #strip the newlines
        for m in range(0, len(self.lines1)):
            self.lines1[m] = self.lines1[m].replace('\n', '')
        for n in range(0, len(self.lines2)):
            self.lines2[n] = self.lines2[n].replace('\n', '')

    def compare(self):
        self.i = 0
        self.j = 0
        col_1 = []
        col_2 = []
        col_3 = []
        
        if self.opts.sort:
            while (self.i < len(self.lines1)):
                flag = True
                for j in range(0, len(self.lines2)):    
                    if (locale.strcoll(self.lines1[self.i], self.lines2[j]) == 0):
                        self.lines2.pop(j)
                        col_1.append("")
                        col_2.append("")
                        col_3.append(self.lines1[self.i])
                        flag = False
                        break
                if flag:
                    col_1.append(self.lines1[self.i])
                    col_2.append("")
                    col_3.append("")
                self.i += 1
            for m in self.lines2:
                col_1.append("")
                col_2.append(m)
                col_3.append("")
        else:
            while ((self.i < len(self.lines1)) and (self.j < len(self.lines2))):
                if (locale.strcoll(self.lines1[self.i], self.lines2[self.j]) == 0):
                    col_1.append("")
                    col_2.append("")
                    col_3.append(self.lines1[self.i])
                    self.i += 1
                    self.j += 1
                elif (locale.strcoll(self.lines1[self.i], self.lines2[self.j]) == -1):
                    col_1.append(self.lines1[self.i])
                    col_2.append("")
                    col_3.append("")
                    self.i += 1
                else:
                    col_1.append("")
                    col_2.append(self.lines2[self.j])
                    col_3.append("")
                    self.j += 1
            #append the rest of lines1
            while (self.i < len(self.lines1)):
                col_1.append(self.lines1[self.i])
                col_2.append("")
                col_3.append("")
                self.i += 1
            #append the rest of lines2
            while (self.j < len(self.lines2)):
                col_1.append("")
                col_2.append(self.lines2[self.j])
                col_3.append("")
                self.j += 1

        result = [col_1, col_2, col_3]
        return result

def main():
    version_msg = "%prog 2.0"
    usage_msg = """%prog [OPTION]... FILE1 FILE2

the POSIX comm command, comparing FILE1 and FILE2."""

    parser = OptionParser(version=version_msg,
                          usage=usage_msg)
    parser.add_option("-u",
                      action="store_true", dest="sort", default=False,
                      help="assumes both files are unsorted (default False)")
    parser.add_option("-1",
                      action="store_false", dest="enable_col_1", default=True,
                      help="-1 disables column 1 (col 1 is enabled by default)")
    parser.add_option("-2",
                      action="store_false", dest="enable_col_2", default=True,
                      help="-2 disables column 1 (col 2 is enabled by default)")
    parser.add_option("-3",
                      action="store_false", dest="enable_col_3", default=True,
                      help="-3 disables column 1 (col 3 is enabled by default)")
    options, args = parser.parse_args(sys.argv[1:])

    if len(args) != 2:
        parser.error("wrong number of operands")
    file1 = args[0]
    file2 = args[1]

    generator = comm(file1, file2, options)
    columns = generator.compare()
    output = []
    for j in range(0, len(columns[0])):
        temp = ""
        if options.enable_col_1:
            temp = temp + columns[0][j] + "\t"
        if options.enable_col_2:
            temp = temp + columns[1][j] + "\t"
        if options.enable_col_3:
            temp = temp + columns[2][j] + "\t"
        output.append(temp)
    for s in output:
        if ("" == s.replace('\n', '').replace('\t', '')):
            pass
        else:
            sys.stdout.write(s)
            sys.stdout.write("\n")

if __name__ == "__main__":
    main()
