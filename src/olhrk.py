
import inkex
import gettext
import copy
import io
import os.path
import json
import ctypes
from lxml import etree


class OlHrk(inkex.Effect): 

    @classmethod
    def doc_template(cls): 
        return '''<?xml version="1.0" encoding="UTF-8" standalone="no"?>
<svg
   xmlns="http://www.w3.org/2000/svg"
   >
</svg>
'''
    @classmethod
    def init_oldl(cls):
        """ initialize oldl """
        json_builder_path = os.path.join(
            os.path.dirname(os.path.abspath(__file__)), "json_builder")

        json_parser_path = os.path.join(
            os.path.dirname(os.path.abspath(__file__)), "json_parser")

        
        ctypes.WinDLL(cls.to_filepath(json_builder_path))
        ctypes.WinDLL(cls.to_filepath(json_parser_path))
        
        oldl_hdl = ctypes.WinDLL(
            cls.to_filepath(cls.get_oldl_path()))
        client_create = oldl_hdl.oldl_client_create
        client_create.res_type = ctypes.c_void_p

        client_release = oldl_hdl.oldl_client_release 
        client_release.res_type = ctypes.c_uint
        client_release.argtypes = [ctypes.c_void_p] 

        client_load_data = oldl_hdl.oldl_client_load_data
        client_load_data.res_type = ctypes.c_int
        client_load_data.argtypes = [
            ctypes.c_void_p, 
            ctypes.c_char_p, ctypes.c_uint,
            ctypes.c_char_p]

        client_connect = oldl_hdl.oldl_client_connect
        client_connect.res_type = ctypes.c_int
        client_connect.argtypes = [ctypes.c_void_p]

        client_disconnect = oldl_hdl.oldl_client_disconnect
        client_disconnect.res_type = ctypes.c_int
        client_disconnect.argtypes = [ctypes.c_void_p]




        cls.oldl_hdl_value = oldl_hdl
        pass

     
    @classmethod
    def to_filepath(cls, path):
        return path.replace('\\', '/') 

    @classmethod
    def get_oldl_hdl(cls):
        """ get oldl module handle """
        if not hasattr(cls, 'oldl_hdl_value'):
            cls.init_oldl()   
        return cls.oldl_hdl_value

    @classmethod
    def client_release(cls, dl_obj):
        """ 
            Release client object.
            It decrements reference count.
        """
        release = cls.get_oldl_hdl().oldl_client_release 
        return release(dl_obj)

    @classmethod
    def client_create(cls):
        """ create a client to send processing data to HARUKA. """
        create = cls.get_oldl_hdl().oldl_client_create
        return create()

    @classmethod
    def client_load_data(cls, dl_obj, str_data, data_name):
        data_name_zero = data_name + '\0'  

        str_data_enc = str_data.encode()
        data_name_zero_enc = data_name_zero.encode()
        data_raw = ctypes.create_string_buffer(str_data_enc,
            len(str_data_enc))
        data_type_raw = ctypes.create_string_buffer(
            data_name_zero_enc, len(str_data_enc))
        load_data = cls.get_oldl_hdl().oldl_client_load_data
        return load_data(dl_obj, data_raw, len(data_raw), data_type_raw)


    @classmethod
    def client_connect(cls, dl_obj):
        connect = cls.get_oldl_hdl().oldl_client_connect     
        return connect(dl_obj)
    
    @classmethod
    def client_disconnect(cls, dl_obj):
        disconnect = cls.get_oldl_hdl().oldl_client_disconnect     
        return disconnect(dl_obj)

    @classmethod
    def str_to_hex_str(cls, str_obj):
        result = '' 
        for ch in str_obj:
            result += '{0:0>2x}'.format(ord(ch))
        return result

        
    @classmethod
    def get_oldl_path(cls):
        result = os.path.join(
            os.path.dirname(os.path.abspath(__file__)), "oldl")
        return result 


    def __init__(self):
        inkex.Effect.__init__(self)

    def create_doc(self):
        doc = etree.parse(io.BytesIO(self.doc_template().encode('utf-8'))) 
        src_doc = self.document
        width = src_doc.getroot().get("width") 
        if width:
            doc.getroot().set("width", width)
        height = src_doc.getroot().get("height")
        if height:
            doc.getroot().set("height", height)
        view_box = src_doc.getroot().get("viewBox")
        if view_box:
            doc.getroot().set("viewBox", view_box)
        return doc 
    def effect(self):
        elem_root = self.selected
        

        
        doc = self.create_doc()

        
 
        for key in elem_root:
            elem = copy.deepcopy(elem_root[key])
            doc.getroot().append(elem)
             
        proc_data = self.create_processing_data_str(etree.tostring(doc))

        dl_ins = OlHrk.client_create()
        state = OlHrk.client_connect(dl_ins)
        connected = state == 0 
        if connected:
            state = OlHrk.client_load_data(
                dl_ins, proc_data, 'Processing data')
        if connected:
            OlHrk.client_disconnect(dl_ins) 

        OlHrk.client_release(dl_ins)




           
        pass

    def create_processing_data_str(self, svg_str):
        """ create processing data as json. """
        return json.dumps(self.create_processing_data(svg_str), indent=2)

    def create_processing_data(self, svg_str):
        """ create processing data as dictionary object"""
        result = dict()
        result['data'] = self.str_to_hex_str(svg_str)    
        result['data_type'] = '.svg'
        return result 

if __name__ == '__main__':
    e = OlHrk()
    e.affect()
# vi: se ts=4 sw=4 et:
