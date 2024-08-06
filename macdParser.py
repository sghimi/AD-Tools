import zipfile, sys
import xml.etree.ElementTree as ET

# namespace for word XML tags:
NS_W = '{http://schemas.openxmlformats.org/wordprocessingml/2006/main}'

# XML tags in Word forms:
TAG_FIELD         = NS_W+'sdt'
TAG_FIELDPROP     = NS_W+'sdtPr'
TAG_FIELDTAG      = NS_W+'tag'
ATTR_FIELDTAGVAL  = NS_W+'val'
TAG_FIELD_CONTENT = NS_W+'sdtContent'
TAG_RUN           = NS_W+'r'
TAG_TEXT          = NS_W+'t'
TAG_BREAK         = NS_W+'br'


def parse_multiline (field_content_elem):

    value = ''
    # iterate over all children elements
    for elem in field_content_elem.iter():
        # extract text:
        if elem.tag == TAG_TEXT:
            value += elem.text
        # and line breaks:
        elif elem.tag == TAG_BREAK:
            value += '\n'
    return value


def parse_form(filename):
    fields = {}
    zfile = zipfile.ZipFile(filename)
    form = zfile.read('word/document.xml')
    xmlroot = ET.fromstring(form)
    for field in xmlroot.iter(TAG_FIELD):
        field_tag = field.find(TAG_FIELDPROP+'/'+TAG_FIELDTAG)
        if field_tag is not None:
            tag = field_tag.get(ATTR_FIELDTAGVAL, None)
            field_content = field.find(TAG_FIELD_CONTENT)
            if field_content is not None:
                value = parse_multiline(field_content)
                fields[tag] = value
    zfile.close()
    return fields


if __name__ == '__main__':
    

    fields = parse_form(sys.argv[1])
    fList = []
    #Filter only filled forms
    for tag, value in fields.items():
        if value == "Click or tap here to enter text." or value =="Choose an item.":
            continue

        print('%s = "%s"' % (tag, value))



