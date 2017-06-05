<?xml version="1.0" encoding="UTF-8"?>

<!-- ################################################################################################ 
     Executable Tests for Data Specification on Protected Sites 
     Protected Sites  application schema version 4.0       
     ################################################################################################  
     Author: Stefania Morrone @Epsilon Italia               
     s.morrone@epsilon-italia.it                           
     eENVplus project www.eenvplus.eu                  
     ################################################################################################ 
     This work is licensed under the Creative Commons Attribution-ShareAlike 4.0 International License.
     To view a copy of this license, visit http://creativecommons.org/licenses/by-sa/4.0/.  
     ################################################################################################ 
     
     ATS tests of Protected Sites Data Specification D2.8.I.9_v3.2 covered by this schematron: 
        A.1.3 Value test  
        A.1.6 Constraints test 
        A.1.7 Geometry representation test 
        A.2.1 Datum test 
        A.2.2 Coordinate reference system test
        A.5.2 CRS publication test 
      
      This schematron also tests that complete and unique inspireId is provided for each spatial object
     ################################################################################################ -->

<sch:schema xmlns:sch="http://purl.oclc.org/dsdl/schematron"
    xmlns:gml="http://www.opengis.net/gml/3.2" xmlns:xlink="http://www.w3.org/1999/xlink"  xmlns:dct="http://purl.org/dc/terms/"
    xmlns:ps="http://inspire.ec.europa.eu/schemas/ps/4.0">
    <sch:title>Schematron constraints for INSPIRE PS</sch:title>
    <sch:ns prefix="sch" uri="http://purl.oclc.org/dsdl/schematron"/>
    <sch:ns prefix="gml" uri="http://www.opengis.net/gml/3.2"/>
    <sch:ns prefix="xlink" uri="http://www.w3.org/1999/xlink"/>
    <sch:ns prefix="ps" uri="http://inspire.ec.europa.eu/schemas/ps/4.0"/>
    <sch:ns prefix="gmd" uri="http://www.isotc211.org/2005/gmd"/>
    <sch:ns prefix="base" uri="http://inspire.ec.europa.eu/schemas/base/3.3"/>
    <sch:ns prefix="base2" uri="http://inspire.ec.europa.eu/schemas/base2/1.0"/>
    <sch:ns prefix="rdf" uri="http://www.w3.org/1999/02/22-rdf-syntax-ns#"/>
    <sch:ns prefix="dct" uri="http://purl.org/dc/terms/"/>
   
    <sch:let name="codelist" value="document('http://inspire.ec.europa.eu/codelist/DesignationSchemeValue/DesignationSchemeValue.en.rdf')" />
    
    <!--    
    ################################################################################################################################ 
    
    This pattern tests that the InspireID is unique and its subfileds are not left blank.-->
    
    <sch:pattern>
        <sch:title> Complete and unique inspireId must be provided</sch:title>
        <sch:rule context="ps:inspireID">
            <sch:let name="localId" value="./base:Identifier/base:localId"/>
            <sch:let name="namespace" value="./base:Identifier/base:namespace"/>
            <sch:let name="uniqueId" value="count(/*//base:Identifier[base:namespace = $namespace][base:localId = $localId]/..)"/>
            <sch:assert test="( (string-length($localId)>0) and (string-length($namespace)>0) and ($uniqueId =1) )">  
               ERROR DESCRIPTION:
               Complete and unique InspireId must be provided -  Test is made that localId and namespace are not blank fields and that number of occurence is 1.
               Current instance values are localId: '<sch:value-of select="$localId"/>' - namespace: '<sch:value-of select="$namespace"/>'. The number of occurences for this InspireId is <sch:value-of select="$uniqueId"/> 
            </sch:assert>

        </sch:rule>
    </sch:pattern>
        
    <!-- ################################################################################################################################ 
    A.1.3  Value test
    Purpose:  Verify  whether  all  attributes  or  association  roles  whose  value  type  is  a  code  list  or enumeration take the values set out therein. 
    NOTE 1 to the A.1.3 test states that 'This test is not applicable to code lists with extensibility ―open or ―any '.
    As the http://inspire.ec.europa.eu/codelist/DesignationSchemeValue/DesignationSchemeValue.en.xml codelist is extensible with any value, 
    there's no assert failing if the designation scheme value does not belong to the DesignationSchemeValue codelist. 
    Meanwhile if the designation scheme value is present in the DesignationSchemeValue codelist,the values in the relevant DesignationValue codelist are checked.
    A.1.6  Constraints test
    Purpose:  Verification  whether  the  instances  of  spatial  object  and/or  data  types  provided  in  the dataset adhere to the constraints specified 
    in the target application schema(s). 
    In the case of PS, there is only the following constraint to be verified:
    Designation constraint : Sites must use designations from an appropriate designation scheme, and the designation code value must agree with the designation scheme. -->
    
    <sch:pattern>
        <sch:title>designation value in accordance with Codelist</sch:title>
        <sch:rule context="ps:DesignationType">
            <sch:let name="designation_scheme" value="ps:designationScheme/@xlink:href"/>
            <sch:let name="designation_name" value="ps:designation/@xlink:href"/>         
            <sch:let name="inDictionary" value="$codelist/rdf:RDF/rdf:Description/dct:hasPart[@rdf:resource = $designation_scheme] " />
            <sch:let name="inRightCodelist" value="
                (ps:designationScheme/@xlink:href='http://inspire.ec.europa.eu/codelist/DesignationSchemeValue/IUCN' and
                ((ps:designation/@xlink:href='http://inspire.ec.europa.eu/codelist/IUCNDesignationValue/managedResourceProtectedArea') or 
                (ps:designation/@xlink:href='http://inspire.ec.europa.eu/codelist/IUCNDesignationValue/nationalPark') or
                (ps:designation/@xlink:href='http://inspire.ec.europa.eu/codelist/IUCNDesignationValue/naturalMonument') or 
                (ps:designation/@xlink:href='http://inspire.ec.europa.eu/codelist/IUCNDesignationValue/strictNatureReserve')or
                (ps:designation/@xlink:href='http://inspire.ec.europa.eu/codelist/IUCNDesignationValue/habitatSpeciesManagementArea') or 
                (ps:designation/@xlink:href='http://inspire.ec.europa.eu/codelist/IUCNDesignationValue/protectedLandscapeOrSeascape')or 
                (ps:designation/@xlink:href='http://inspire.ec.europa.eu/codelist/IUCNDesignationValue/wildernessArea'))) 
                or
                (ps:designationScheme/@xlink:href='http://inspire.ec.europa.eu/codelist/DesignationSchemeValue/natura2000' and
                ((ps:designation/@xlink:href='http://inspire.ec.europa.eu/codelist/Natura2000DesignationValue/proposedSiteOfCommunityImportance') or
                (ps:designation/@xlink:href='http://inspire.ec.europa.eu/codelist/Natura2000DesignationValue/proposedSpecialProtectionArea') or 
                (ps:designation/@xlink:href='http://inspire.ec.europa.eu/codelist/Natura2000DesignationValue/siteOfCommunityImportance') or 
                (ps:designation/@xlink:href='http://inspire.ec.europa.eu/codelist/Natura2000DesignationValue/specialAreaOfConservation') or 
                (ps:designation/@xlink:href='http://inspire.ec.europa.eu/codelist/Natura2000DesignationValue/specialProtectionArea'))) 
                
                or  
                (ps:designationScheme/@xlink:href='http://inspire.ec.europa.eu/codelist/DesignationSchemeValue/UNESCOWorldHeritage' and 
                ((ps:designation/@xlink:href='http://inspire.ec.europa.eu/codelist/UNESCOWorldHeritageDesignationValue/cultural') or 
                (ps:designation/@xlink:href='http://inspire.ec.europa.eu/codelist/UNESCOWorldHeritageDesignationValue/mixed') or
                (ps:designation/@xlink:href='http://inspire.ec.europa.eu/codelist/UNESCOWorldHeritageDesignationValue/natural')))  
                
                or
                (ps:designationScheme/@xlink:href='http://inspire.ec.europa.eu/codelist/DesignationSchemeValue/ramsar' and 
                ((ps:designation/@xlink:href='http://inspire.ec.europa.eu/codelist/RamsarDesignationValue/ramsar'))) 
                
                or
                (ps:designationScheme/@xlink:href='http://inspire.ec.europa.eu/codelist/DesignationSchemeValue/UNESCOManAndBiosphereProgramme' and 
                ((ps:designation/@xlink:href='http://inspire.ec.europa.eu/codelist/UNESCOManAndBiosphereProgrammeDesignationValue/BiosphereReserve')))
                
                or
                (ps:designationScheme/@xlink:href='http://inspire.ec.europa.eu/codelist/DesignationSchemeValue/nationalMonumentsRecord' and
                ((ps:designation/@xlink:href='http://inspire.ec.europa.eu/codelist/NationalMonumentsRecordDesignationValue/agricultureAndSubsistence') or
                (ps:designation/@xlink:href='http://inspire.ec.europa.eu/codelist/NationalMonumentsRecordDesignationValue/civil') or
                (ps:designation/@xlink:href='http://inspire.ec.europa.eu/codelist/NationalMonumentsRecordDesignationValue/commemorative') or
                (ps:designation/@xlink:href='http://inspire.ec.europa.eu/codelist/NationalMonumentsRecordDesignationValue/commercial') or
                (ps:designation/@xlink:href='http://inspire.ec.europa.eu/codelist/NationalMonumentsRecordDesignationValue/communications') or 
                (ps:designation/@xlink:href='http://inspire.ec.europa.eu/codelist/NationalMonumentsRecordDesignationValue/defence') or
                (ps:designation/@xlink:href='http://inspire.ec.europa.eu/codelist/NationalMonumentsRecordDesignationValue/domestic') or 
                (ps:designation/@xlink:href='http://inspire.ec.europa.eu/codelist/NationalMonumentsRecordDesignationValue/education') or 
                (ps:designation/@xlink:href='http://inspire.ec.europa.eu/codelist/NationalMonumentsRecordDesignationValue/gardensParksAndUrbanSpaces') or
                (ps:designation/@xlink:href='http://inspire.ec.europa.eu/codelist/NationalMonumentsRecordDesignationValue/healthAndWelfare') or
                (ps:designation/@xlink:href='http://inspire.ec.europa.eu/codelist/NationalMonumentsRecordDesignationValue/industrial') or 
                (ps:designation/@xlink:href='http://inspire.ec.europa.eu/codelist/NationalMonumentsRecordDesignationValue/maritime') or 
                (ps:designation/@xlink:href='http://inspire.ec.europa.eu/codelist/NationalMonumentsRecordDesignationValue/monument') or 
                (ps:designation/@xlink:href='http://inspire.ec.europa.eu/codelist/NationalMonumentsRecordDesignationValue/recreational') or 
                (ps:designation/@xlink:href='http://inspire.ec.europa.eu/codelist/NationalMonumentsRecordDesignationValue/religiousRitualAndFunerary') or 
                (ps:designation/@xlink:href='http://inspire.ec.europa.eu/codelist/NationalMonumentsRecordDesignationValue/settlement') or 
                (ps:designation/@xlink:href='http://inspire.ec.europa.eu/codelist/NationalMonumentsRecordDesignationValue/transport') or
                (ps:designation/@xlink:href='http://inspire.ec.europa.eu/codelist/NationalMonumentsRecordDesignationValue/waterSupplyAndDrainage')))" />
                    
            
            <sch:assert test=" not($inDictionary)or (($inDictionary) and ($inRightCodelist))">
                
                Erroneous designation value ' <sch:value-of select="$designation_name"/> ' found for
                the '<sch:value-of select="$designation_scheme"/>' designation scheme. 
                
            </sch:assert>
            
        </sch:rule>
    </sch:pattern>	

    <!-- ################################################################################################ 
        A.1.7 Geometry representation test
        Purpose:Verify whether the value domain of spatial properties is restricted as specified in the Commission Regulation No 1089/2010.

        The following pattern therefore tests compliance to  IR (1089 AND 1253) Requirement Article 12 
        "The value domain of spatial properties defined in this Regulation shall be restricted to the Simple Feature spatial schema." 

        The following pattern reuses pieces from the schematron file
        https://github.com/52North/common-xml/blob/master/52n-ogc-schema/src/main/resources/META-INF/xml/gmlsfProfile/2.0/gmlsfL2.sch

        Non-linearly interpolated curves are not included in the OpenGIS® Implementation Specification for Geographic information - 
        Simple feature access - Part 1: Common architecture  [OGC 06-103r3] specification
        ################################################################################################ -->
    <sch:pattern >  
        <sch:rule context="/*//*">
            <!-- Rule to exclude spatial topology types -->
            <sch:assert
                test="not(self::gml:Node|self::gml:Edge|self::gml:Face|self::gml:TopoSolid|self::gml:TopoPoint|self::gml:TopoCurve|self::gml:TopoSurface|self::gml:TopoVolume|self::gml:TopoComplex)"
                >ERROR DESCRIPTION: Spatial properties are limited to the set of geometric types
                consisting of point, curve with linear and/or circular arc interpolation, planar
                surface, or aggregates thereof. Spatial topology is excluded. </sch:assert>
            
            <sch:assert
                test="not(self::gml:Curve) or self::gml:Curve/gml:segments[gml:LineStringSegment]">
                ERROR DESCRIPTION:Curves (standalone or within surfaces) must have linear
                interpolation (LineString) </sch:assert>
                      
            <!-- Rule for constraints on planar surfaces -->
            <sch:assert
                test="not(self::gml:OrientableSurface|self::gml:CompositeSurface|self::gml:PolyhedralSurface|self::gml:Tin|self::gml:TriangulatedSurface)"
                > ERROR DESCRIPTION: Planar surface types are restricted to Polygon or MultiSurface
                elements. </sch:assert>
            
            <!-- Rule for constraints on GeometryPropertyType -->
            <sch:assert
                test="not(self::gml:Solid|self::gml:MultiSolid|self::gml:CompositeSolid|self::gml:CompositeCurve|self::gml:Grid)"
                > ERROR DESCRIPTION: Supported geometry types are restricted to point, curve with
                linear and/or circular arc interpolation, planar surface, or aggregates thereof. </sch:assert>
            
            <!-- Rule for geometry coordinates of points and circles by
                centerpoint -->
            <sch:assert test="count(self::gml:Point/gml:pos) = count(self::gml:Point/*)"> ERROR
                DESCRIPTION: Geometry coordinates shall only be specified using the gml:pos element
                for gml:Point. </sch:assert>
            <sch:assert
                test="count(self::gml:CircleByCenterPoint/gml:pos|self::gml:CircleByCenterPoint/gml:radius) = count(self::gml:CircleByCenterPoint/*)"
                > ERROR DESCRIPTION: Geometry coordinates shall only be specified using the gml:pos
                element for gml:CircleByCenterPoint. </sch:assert>
            
            <!-- Rules for geometry coordinates in geometries other than points -->
            <sch:assert
                test="count(self::gml:LineStringSegment/gml:posList) =
                count(self::gml:LineStringSegment/*)"
                > ERROR DESCRIPTION: Geometry coordinates shall only be specified using the
                gml:posList element for gml:LineStringSegment. </sch:assert>
            <sch:assert
                test="count(self::gml:LinearRing/gml:posList) =
                count(self::gml:LinearRing/*)"
                > ERROR DESCRIPTION: Geometry coordinates shall only be specified using the
                gml:posList element for gml:LinearRing. </sch:assert>
            <sch:assert test="count(self::gml:Arc/gml:posList) = count(self::gml:Arc/*)"> ERROR
                DESCRIPTION: Geometry coordinates shall only be specified using the gml:posList
                element for gml:Arc. </sch:assert>
            <sch:assert
                test="count(self::gml:Circle/gml:posList) =
                count(self::gml:Circle/*)"
                > ERROR DESCRIPTION: Geometry coordinates shall only be specified using the
                gml:posList element for gml:Circle. </sch:assert>
            
            <!-- Rules for aggregate geometry types -->
            <sch:assert test="not(self::gml:MultiPoint/gml:pointMembers)"> ERROR DESCRIPTION: This
                profile restricts instance documents to using the property container gml:pointMember
                for the MultiPoint geometry type. </sch:assert>
            <sch:assert test="not(self::gml:MultiCurve/gml:curveMembers)"> ERROR DESCRIPTION: This
                profile restricts instance documents to using the property container gml:curveMember
                for the MultiCurve geometry type. </sch:assert>
            <sch:assert test="not(self::gml:MultiSurface/gml:surfaceMembers)"> ERROR DESCRIPTION:
                This profile restricts instance documents to using the property container
                gml:surfaceMember for the MultiSurface geometry type. </sch:assert>
            <sch:assert test="not(self::gml:MultiGeometry/gml:geometryMembers)"> ERROR DESCRIPTION:
                This profile restricts instance documents to using the property container
                gml:geometryMember for the MultiGeometry geometry type. </sch:assert>
            
            <!-- Rule for content of surfaces -->
            <sch:assert
                test="count(self::gml:Surface/gml:patches/gml:PolygonPatch) =
                count(self::gml:Surface/gml:patches/*)"
                > ERROR DESCRIPTION: The content of gml:Surface elements is restricted to
                gml:PolygonPatch patches. </sch:assert>
            <sch:assert test="not(self::*/@srsDimension &gt; 3)"> ERROR DESCRIPTION: Coordinate
                reference systems may have 1, 2 or 3 dimensions. </sch:assert>
        </sch:rule>
    </sch:pattern>
    
    <!-- Tests on coordinate reference systems
        
    INSPIRE Technical Guidelines propose 'to use the http URIs provided by the Open Geospatial Consortium as coordinate reference system identifiers.
    These are based on and redirect to the definition in the EPSG Geodetic Parameter Registry (http://www.epsg-registry.org/)'. 
    TG Requirement is present in all Data Specifications stating that 
    'the identifiers listed in 'relevant' Table shall be used for referring to the coordinate reference systems used in a data set'.
    
    In the Data Specification on Protected Sites, abovementioned TG Requirement is nr.2 and the 'relevant' table with http URIs for the default coordinate reference systems is Table 3 provided in Section 6. 
    A NOTE preceiding Table 3 states that 'CRS identifiers may be used e.g. in: – data encoding, – data set and service metadata, and – requests to INSPIRE network services'.
       
    Following pattern test compliance to 
    A.2.1 Datum test (Verify whether each instance of a spatial object type is given with reference to one of the (geodetic) datums specified in the target specification)
    A.2.2 Coordinate reference system test (Verify whether the two- and three-dimensional coordinate reference systems are used as defined in section 6.)
    A.5.2 CRS publication test (Verify whether the identifiers and the parameters of coordinate reference system are published in common registers)
    
    Be aware that 
    1) to automate this test an implementation choice is made to allow only identifiers referring to EPSG codes listed in Table 3.
       Should you decide to refer to identifiers not included in Table 3, abovementioned tests should be executed manually.
   
    2) should you allow only the http URI encoding for srsName attribute, the following pattern can also be used to test the compliance to
    A.8.2 CRS http URI test:   
    'Test Method: Compare the URI of the dataset with the URIs in the table.'
    -->
    
    <sch:pattern>
        <sch:rule context="/*//*">
            
            <sch:let name="srs_name" value="self::*/@srsName"/>
            
            <sch:assert
                test=" (not (self::*/@srsName) or
                (
                (@srsName='urn:ogc:def:crs:EPSG::4936') or(@srsName='http://www.opengis.net/def/crs/EPSG/0/4936') or (@srsName='EPSG:4936') 
                or 
                (@srsName='urn:ogc:def:crs:EPSG::4937') or(@srsName='http://www.opengis.net/def/crs/EPSG/0/4937') or (@srsName='EPSG:4937')
                or
                (@srsName='urn:ogc:def:crs:EPSG::4258') or(@srsName='http://www.opengis.net/def/crs/EPSG/0/4258') or (@srsName='EPSG:4258') 
                or
                (@srsName='urn:ogc:def:crs:EPSG::3035') or(@srsName='http://www.opengis.net/def/crs/EPSG/0/3035') or (@srsName='EPSG:3035')
                or
                (@srsName='urn:ogc:def:crs:EPSG::3034') or(@srsName='http://www.opengis.net/def/crs/EPSG/0/3034') or (@srsName='EPSG:3034')
                or
                (@srsName='urn:ogc:def:crs:EPSG::3038') or(@srsName='http://www.opengis.net/def/crs/EPSG/0/3038') or (@srsName='EPSG:3038')
                or
                (@srsName='urn:ogc:def:crs:EPSG::3039') or(@srsName='http://www.opengis.net/def/crs/EPSG/0/3039') or (@srsName='EPSG:3039')
                or
                (@srsName='urn:ogc:def:crs:EPSG::3040') or(@srsName='http://www.opengis.net/def/crs/EPSG/0/3040') or (@srsName='EPSG:3040')
                or
                (@srsName='urn:ogc:def:crs:EPSG::3041') or(@srsName='http://www.opengis.net/def/crs/EPSG/0/3041') or (@srsName='EPSG:3041')
                or
                (@srsName='urn:ogc:def:crs:EPSG::3042') or(@srsName='http://www.opengis.net/def/crs/EPSG/0/3042') or (@srsName='EPSG:3042')
                or
                (@srsName='urn:ogc:def:crs:EPSG::3043') or(@srsName='http://www.opengis.net/def/crs/EPSG/0/3043') or (@srsName='EPSG:3043')
                or
                (@srsName='urn:ogc:def:crs:EPSG::3044') or(@srsName='http://www.opengis.net/def/crs/EPSG/0/3044') or (@srsName='EPSG:3044')
                or
                (@srsName='urn:ogc:def:crs:EPSG::3045') or(@srsName='http://www.opengis.net/def/crs/EPSG/0/3045') or (@srsName='EPSG:30450')
                or
                (@srsName='urn:ogc:def:crs:EPSG::3046') or(@srsName='http://www.opengis.net/def/crs/EPSG/0/3046') or (@srsName='EPSG:3046')
                or
                (@srsName='urn:ogc:def:crs:EPSG::3047') or(@srsName='http://www.opengis.net/def/crs/EPSG/0/3047') or (@srsName='EPSG:3047')
                or
                (@srsName='urn:ogc:def:crs:EPSG::3048') or(@srsName='http://www.opengis.net/def/crs/EPSG/0/3048') or (@srsName='EPSG:3048')
                or
                (@srsName='urn:ogc:def:crs:EPSG::3049') or(@srsName='http://www.opengis.net/def/crs/EPSG/0/3049') or (@srsName='EPSG:3049')
                or 
                (@srsName='urn:ogc:def:crs:EPSG::3050') or(@srsName='http://www.opengis.net/def/crs/EPSG/0/3050') or (@srsName='EPSG:3050')
                or
                (@srsName='urn:ogc:def:crs:EPSG::3051') or(@srsName='http://www.opengis.net/def/crs/EPSG/0/3051') or (@srsName='EPSG:3051')
                or
                (@srsName='urn:ogc:def:crs:EPSG::5730') or(@srsName='http://www.opengis.net/def/crs/EPSG/0/5730') or (@srsName='EPSG:5730')
                or
                (@srsName='urn:ogc:def:crs:EPSG::7409') or(@srsName='http://www.opengis.net/def/crs/EPSG/0/7409') or (@srsName='EPSG:7409')) 
                )"
                > ERROR DESCRIPTION: The Coordinate reference system value " <sch:value-of
                    select="$srs_name"/>" defined for the dataset is not allowed!Please refer to EPSG codes listed in Table 3 of Protected Sites Data Specification for allowed values </sch:assert> 
            
        </sch:rule>
                        
    </sch:pattern> 
    
</sch:schema>