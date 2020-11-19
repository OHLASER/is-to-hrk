import gettext

class Strtmpl:
    @classmethod
    def strmapping(cls):
        _ = gettext.gettext
        result = {
            'send_to_haruka' : _('Send To HARUKA'),
            'export': _('Export') 
        }
        return result 

    def __init__(self):
        """ constructor """ 

        pass

    def run(self):
        fh = open('src/olhrk.inx', 'r')
        contents = fh.read() 
        str_mapping = Strtmpl.strmapping()
        contents = contents.format(
            send_to_haruka = str_mapping['send_to_haruka']) 
        print(contents)
        pass

if __name__ == '__main__':
    strtmpl = Strtmpl()
    strtmpl.run() 

# vi: se ts=4 sw=4 et:
