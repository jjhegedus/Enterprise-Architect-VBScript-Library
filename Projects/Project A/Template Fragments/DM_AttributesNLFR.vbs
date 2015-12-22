'[path=\Projects\Project A\Template fragments]
'[group=Template fragments]
option explicit

!INC Local Scripts.EAConstants-VBScript
!INC Atrias Scripts.Util

'
' Script Name: 
' Author: 
' Purpose: 
' Date: 
'
function MyRtfData (objectID, tagname)
	'msgbox "starting MyRTFdata fo element" & objectID
	'MyRtfData = "<?xml version=""1.0""?><EADATA><Dataset_0><Data><Row><ConstraintName>constraint 1</ConstraintName><DescriptionNL formatted=""1"">Hier staat de nederlandse bescrijving van deze constraint in &lt;b&gt;RichText&lt;/b&gt; (1)</DescriptionNL><DescriptionFR formatted=""1"">ici le fran�ais avec ��� characters &lt;b&gt;d�me&lt;/b&gt;</DescriptionFR></Row><Row><ConstraintName>constraint 2</ConstraintName><DescriptionNL formatted=""1"">Hier staat de nederlandse bescrijving van deze constraint in &lt;b&gt;RichText (2)&lt;/b&gt;</DescriptionNL><DescriptionFR formatted=""1"">ici le fran�ais avec ��� characters &lt;b&gt;d�me (2)&lt;/b&gt;</DescriptionFR></Row></Data></Dataset_0></EADATA>"
	dim xmlDOM 
	set  xmlDOM = CreateObject( "Microsoft.XMLDOM" )
	xmlDOM.validateOnParse = false
	xmlDOM.async = false
	 
	dim node 
	set node = xmlDOM.createProcessingInstruction( "xml", "version='1.0'")
    xmlDOM.appendChild node
'
	dim xmlRoot 
	set xmlRoot = xmlDOM.createElement( "EADATA" )
	xmlDOM.appendChild xmlRoot

	dim xmlDataSet
	set xmlDataSet = xmlDOM.createElement( "Dataset_0" )
	xmlRoot.appendChild xmlDataSet
	 
	dim xmlData 
	set xmlData = xmlDOM.createElement( "Data" )
	xmlDataSet.appendChild xmlData
	
	'loop the Attributes
	dim element as EA.Element
	set element = Repository.GetElementByID(objectID)
	dim attribute as EA.Attribute

	if element.Attributes.Count > 0 then
		for each attribute in  element.Attributes
			addRow xmlDOM, xmlData, attribute
		next
		MyRtfData = xmlDOM.xml
	else
		'no attributes, so return empty string
		MyRtfData = ""
	end if
end function

function addRow(xmlDOM, xmlData, attribute)
	
	dim xmlRow
	set xmlRow = xmlDOM.createElement( "Row" )
	xmlData.appendChild xmlRow
	
	'Attribute name
	dim xmlAttributeName
	set xmlAttributeName = xmlDOM.createElement( "AttributeName" )	
	xmlAttributeName.text = attribute.Name
	xmlRow.appendChild xmlAttributeName

	dim descriptionfull
	descriptionfull = attribute.Notes
	
	'description NL
	dim formattedAttr 
	set formattedAttr = xmlDOM.createAttribute("formatted")
	formattedAttr.nodeValue="1"
	dim xmlDescNL
	set xmlDescNL = xmlDOM.createElement( "DescriptionNL" )	
	xmlDescNL.text = getTagContent(descriptionfull, "NL")
	xmlDescNL.setAttributeNode(formattedAttr)
	xmlRow.appendChild xmlDescNL
	
	'description FR
	set formattedAttr = xmlDOM.createAttribute("formatted")
	formattedAttr.nodeValue="1"
	dim xmlDescFR
	set xmlDescFR = xmlDOM.createElement( "DescriptionFR" )			
	xmlDescFR.text = getTagContent(descriptionfull, "FR")
	xmlDescFR.setAttributeNode(formattedAttr)
	xmlRow.appendChild xmlDescFR
	
	'multiplicity
	dim xmlMultiplicity
	set xmlMultiplicity = xmlDOM.createElement( "Multiplicity" )			
	xmlMultiplicity.text = attribute.LowerBound & ".." & attribute.UpperBound
	xmlRow.appendChild xmlMultiplicity
	
	'IsID
	dim xmlIsID
	set xmlIsID = xmlDOM.createElement( "IsID" )
	if attribute.IsID then
		xmlIsID.text = "Y"
	else
		xmlIsID.text = "N"
	end if
	xmlRow.appendChild xmlIsID
	
	'Values
	dim xmlValues
	set xmlValues = xmlDOM.createElement( "Values" )			
	xmlValues.text = "TODO - bekijken met TOM"
	xmlRow.appendChild xmlValues
	
	'Format
	dim xmlFormat
	set xmlFormat = xmlDOM.createElement( "Format" )			
	xmlFormat.text = attribute.Type
	xmlRow.appendChild xmlFormat
	
end function

'msgbox MyRtfData(38999, "")