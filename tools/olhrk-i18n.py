import gettext
import getopt
import sys
import os

class OlhrkI18n:
    @classmethod
    def option_mapping(cls):
        result = [
            [('-h', '--help'), '', [
                'display these messages.'
            ]],
            [('-i', '--input='), '<FILE>', [
                'input file.'
            ]],
            [('-o', '--output='), '<FILE>', [
                'output file.'
            ]],
            [('-l', '--locale='), '<LOCALE>', [
                'set locale'
            ]]
        ] 
        return result 

    @classmethod
    def option_mapping_str(cls):
        mapping = cls.option_mapping()
        result = '' 
        for entry in mapping:
            str_fmt =  '{0: <14s}{1: <10}{2: <50}\n'
            opt_str = '{0},{1}'.format(entry[0][0], entry[0][1])
            result += str_fmt.format(opt_str, entry[1], entry[2][0]) 
            for desc_idx in range(1, len(entry[2])):
                result += str_fmt.format('', '', entry[2][desc_idx]) 
        return result 

    @property
    def strmapping(self):
        if hasattr(self, 'locale'):
            gettext.bindtextdomain('messages', 'i18n')
            os.environ['LANGUAGE'] = self.locale

        _ = gettext.gettext
        result = {
            'send_to_haruka' : _('Send To HARUKA'),
            'export': _('Export') 
        }
        return result 


    def __init__(self):
        """ constructor """ 
        pass


    def usage(self):
        print(self.option_mapping_str())
        pass

    def parse_option(self, options):
        opts, args = getopt.getopt(
            options, 'hi:o:l:', ['help', 'input=', 'output=', 'locale'])
        for opt, value in opts:
            if opt in ('-h', '--help'):   
                self.usage() 
                sys.exit()
            elif opt in ('-i', '--input'):
                self.input = value 
            elif opt in ('-o', '--output'):
                self.output = value
            elif opt in ('-l', '--locale'):
                self.locale = value
        pass
    

    def run(self):
        if self.input is not None:
            fh = open(self.input, 'r')
            contents = fh.read() 
            str_mapping = self.strmapping
            contents = contents.format(
                send_to_haruka = str_mapping['send_to_haruka'],
                export = str_mapping['export']) 
            
            if hasattr(self, 'output'):
                fo = open(self.output, 'w') 
                fo.write(contents)
                fo.close()
            else:
                print(contents) 
        
        pass

if __name__ == '__main__':
    i18n = OlhrkI18n()
    i18n.parse_option(sys.argv[1:])
    i18n.run() 

# vi: se ts=4 sw=4 et:
