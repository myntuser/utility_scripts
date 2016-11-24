import sys
import re
import collections

try:
	from lxml import etree
	import MySQLdb
	#import oracle
except:
	print("The modules not installed properly")
	sys.exit(1)


if __name__ == "__main__":
	db = MySQLdb.connect(host='localhost', user='root', passwd='root123', db='talend')
	cursor = db.cursor()   
	cursor.execute("show columns from employee")
	root = etree.Element('schema', dbmsId='mysql_id')
	xml = etree.ElementTree(root)
	for item in cursor.fetchall():	
		if "int" in item[1]:
			typ = "INT"
			talend_typ = "id_Integer"
		elif "varchar" in item[1]:
			typ = "VARCHAR"
			talend_typ = "id_String"
		elif "float" in item[1]:
			typ = "FLOAT"
			talend_typ = "id_Float"

		 
		l = re.findall(r'\d+', item[1])
		attrib = dict()
		attrib['label'] = item[0]
		attrib['default'] = ''
		attrib['comment'] = ''
		attrib['length'] = l[0] if len(l) != 0 else ""
		attrib['type'] = typ
		attrib['key'] = 'false'
		attrib['precision'] = '-1'
		attrib['pattern'] = ''
		attrib['nullable'] = 'true'
		attrib['talendType'] = talend_typ
		attrib['originalLength'] = '-1'
		attrib['originalDbColumnName'] = item[0]
		od = collections.OrderedDict(sorted(attrib.items()))
		col = etree.SubElement(root, 'column', od)			
	cursor.close()
	db.close()   
	print etree.tostring(xml, pretty_print = False) 
	xml.write("schema.xml")	
