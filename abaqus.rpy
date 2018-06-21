# -*- coding: mbcs -*-
#
# Abaqus/CAE Release 6.14-1 replay file
# Internal Version: 2014_06_04-20.37.49 134264
# Run by xiaohan on Thu Jun 21 16:14:58 2018
#

# from driverUtils import executeOnCaeGraphicsStartup
# executeOnCaeGraphicsStartup()
#: Executing "onCaeGraphicsStartup()" in the site directory ...
from abaqus import *
from abaqusConstants import *
session.Viewport(name='Viewport: 1', origin=(0.0, 0.0), width=442.647888183594, 
    height=208.674087524414)
session.viewports['Viewport: 1'].makeCurrent()
session.viewports['Viewport: 1'].maximize()
from caeModules import *
from driverUtils import executeOnCaeStartup
executeOnCaeStartup()
session.viewports['Viewport: 1'].partDisplay.geometryOptions.setValues(
    referenceRepresentation=ON)
openMdb(pathName='/home/xiaohan/Desktop/Temp/AbaqusModels/airfoil/airfoil.cae')
#: The model database "/home/xiaohan/Desktop/Temp/AbaqusModels/airfoil/airfoil.cae" has been opened.
session.viewports['Viewport: 1'].setValues(displayedObject=None)
p = mdb.models['Model-1'].parts['airfoil']
session.viewports['Viewport: 1'].setValues(displayedObject=p)
p = mdb.models['Model-1'].Part(name='airfoil-failed', 
    objectToCopy=mdb.models['Model-1'].parts['airfoil'])
mdb.models['Model-1'].parts['airfoil-failed'].Unlock(reportWarnings=False)
del mdb.models['Model-1'].parts['airfoil']
mdb.models['Model-1'].parts.changeKey(fromName='airfoil-failed', 
    toName='airfoil')
import assembly
mdb.models['Model-1'].rootAssembly.regenerate()
p1 = mdb.models['Model-1'].parts['airfoil']
session.viewports['Viewport: 1'].setValues(displayedObject=p1)
p = mdb.models['Model-1'].parts['airfoil']
session.viewports['Viewport: 1'].setValues(displayedObject=p)
p = mdb.models['Model-1'].parts['airfoil']
p.features['Solid extrude-1'].setValues(depth=50.0)
p = mdb.models['Model-1'].parts['airfoil']
p.regenerate()
#* FeatureError: Regeneration failed
p = mdb.models['Model-1'].parts['airfoil']
p.regenerate()
#: Warning: Validity of the geometry was updated after one or more of the selected features.
#: Deleting these features may cause the validity of the geometry to change.
p = mdb.models['Model-1'].parts['airfoil']
p.deleteFeatures(('Partition face-2', 'Partition cell-2', 'Partition cell-1', 
    ))
p = mdb.models['Model-1'].parts['airfoil']
del p.features['Partition face-1']
session.viewports['Viewport: 1'].view.setValues(session.views['Iso'])
#: The contents of viewport "Viewport: 1" have been copied to the clipboard.
#: The contents of viewport "Viewport: 1" have been copied to the clipboard.
session.viewports['Viewport: 1'].view.setValues(nearPlane=273.072, 
    farPlane=464.158, width=340.461, height=183.777, viewOffsetX=6.44337, 
    viewOffsetY=9.71556)
p = mdb.models['Model-1'].parts['airfoil']
f = p.faces
p.DatumPlaneByOffset(plane=f[5], flip=SIDE1, offset=500.0)
session.viewports['Viewport: 1'].view.setValues(session.views['Iso'])
p = mdb.models['Model-1'].parts['airfoil']
del p.features['Datum plane-1']
p = mdb.models['Model-1'].parts['airfoil']
f1 = p.faces
p.DatumPlaneByOffset(plane=f1[5], flip=SIDE1, offset=250.0)
session.viewports['Viewport: 1'].view.setValues(session.views['Iso'])
mdb.save()
#: The model database has been saved to "/home/xiaohan/Desktop/Temp/AbaqusModels/airfoil/airfoil.cae".
mdb.save()
#: The model database has been saved to "/home/xiaohan/Desktop/Temp/AbaqusModels/airfoil/airfoil.cae".
#: The contents of viewport "Viewport: 1" have been copied to the clipboard.
p = mdb.models['Model-1'].parts['airfoil']
s = p.features['Solid extrude-1'].sketch
mdb.models['Model-1'].ConstrainedSketch(name='__edit__', objectToCopy=s)
s1 = mdb.models['Model-1'].sketches['__edit__']
g, v, d, c = s1.geometry, s1.vertices, s1.dimensions, s1.constraints
s1.setPrimaryObject(option=SUPERIMPOSE)
p.projectReferencesOntoSketch(sketch=s1, 
    upToFeature=p.features['Solid extrude-1'], filter=COPLANAR_EDGES)
s1.unsetPrimaryObject()
mdb.models['Model-1'].parts.changeKey(fromName='airfoil', toName='root')
del mdb.models['Model-1'].sketches['__edit__']
p = mdb.models['Model-1'].Part(name='panel', 
    objectToCopy=mdb.models['Model-1'].parts['root'])
session.viewports['Viewport: 1'].setValues(displayedObject=p)
session.viewports['Viewport: 1'].view.setValues(session.views['Iso'])
session.viewports['Viewport: 1'].view.setValues(session.views['Iso'])
session.viewports['Viewport: 1'].view.setValues(session.views['Iso'])
p1 = mdb.models['Model-1'].parts['root']
session.viewports['Viewport: 1'].setValues(displayedObject=p1)
p1 = mdb.models['Model-1'].parts['panel']
session.viewports['Viewport: 1'].setValues(displayedObject=p1)
p = mdb.models['Model-1'].parts['panel']
p.features['Solid extrude-1'].setValues(depth=100.0)
p = mdb.models['Model-1'].parts['panel']
p.regenerate()
p = mdb.models['Model-1'].parts['panel']
p.regenerate()
del mdb.models['Model-1'].parts['panel']
p = mdb.models['Model-1'].parts['root']
session.viewports['Viewport: 1'].setValues(displayedObject=p)
p = mdb.models['Model-1'].parts['root']
s = p.features['Solid extrude-1'].sketch
mdb.models['Model-1'].ConstrainedSketch(name='__edit__', objectToCopy=s)
s2 = mdb.models['Model-1'].sketches['__edit__']
g, v, d, c = s2.geometry, s2.vertices, s2.dimensions, s2.constraints
s2.setPrimaryObject(option=SUPERIMPOSE)
p.projectReferencesOntoSketch(sketch=s2, 
    upToFeature=p.features['Solid extrude-1'], filter=COPLANAR_EDGES)
#: The distance between vertex 3 and vertex 32 is 19.821425 
#: Warning: Cannot continue yet--complete the step or cancel the procedure.
#: Warning: Cannot continue yet--complete the step or cancel the procedure.
session.viewports['Viewport: 1'].view.setValues(cameraPosition=(58.366, 
    -0.520561, 322.436), cameraTarget=(58.366, -0.520561, 0))
session.viewports['Viewport: 1'].view.setValues(nearPlane=7.4569, 
    farPlane=337.415, cameraPosition=(71.0566, -3.85216, 322.436), 
    cameraTarget=(71.0566, -3.85216, 0))
#: Warning: Same entity was selected.
#: Warning: Same entity was selected.
#: The distance between vertex 11 and vertex 39 is 90.238419 
#: The distance between vertex 40 and vertex 39 is 13.110640 
#: The distance between vertex 39 and vertex 35 is 50.427891 
session.viewports['Viewport: 1'].view.setValues(nearPlane=347.473, 
    farPlane=694.276, width=267.81, height=144.562, cameraPosition=(94.4963, 
    1.33666, 670.874), cameraTarget=(94.4963, 1.33666, 0))
s2.copyMove(vector=(10.0, 22.5), objectList=(g[51], g[52], g[47], g[46], 
    g[39]))
s2.unsetPrimaryObject()
#: Warning: Cannot continue yet--complete the step or cancel the procedure.
#: Warning: A temporary sketch __edit__ has been deleted
session.viewports['Viewport: 1'].view.setValues(nearPlane=566.055, 
    farPlane=925.872, width=413.837, height=216.204, viewOffsetX=3.2123, 
    viewOffsetY=0.621538)
del mdb.models['Model-1'].sketches['__edit__']
p = mdb.models['Model-1'].parts['root']
e, d1 = p.edges, p.datums
t = p.MakeSketchTransform(sketchPlane=d1[8], sketchUpEdge=e[13], 
    sketchPlaneSide=SIDE1, sketchOrientation=RIGHT, origin=(80.0, 0.0, 300.0))
s = mdb.models['Model-1'].ConstrainedSketch(name='__profile__', 
    sheetSize=696.99, gridSpacing=17.42, transform=t)
g, v, d, c = s.geometry, s.vertices, s.dimensions, s.constraints
s.setPrimaryObject(option=SUPERIMPOSE)
p = mdb.models['Model-1'].parts['root']
p.projectReferencesOntoSketch(sketch=s, filter=COPLANAR_EDGES)
session.viewports['Viewport: 1'].view.setValues(nearPlane=538.154, 
    farPlane=855.841, width=97.2008, height=52.4681, cameraPosition=(109.472, 
    2.84692, 846.998), cameraTarget=(109.472, 2.84692, 150))
s.Line(point1=(80.0, 0.0), point2=(63.567626953125, 2.09392905235291))
p = mdb.models['Model-1'].parts['root']
e1, d2 = p.edges, p.datums
p.Wire(sketchPlane=d2[8], sketchUpEdge=e1[13], sketchPlaneSide=SIDE1, 
    sketchOrientation=RIGHT, sketch=s)
s.unsetPrimaryObject()
del mdb.models['Model-1'].sketches['__profile__']
p = mdb.models['Model-1'].parts['root']
s1 = p.features['Wire-1'].sketch
mdb.models['Model-1'].ConstrainedSketch(name='__edit__', objectToCopy=s1)
s2 = mdb.models['Model-1'].sketches['__edit__']
g, v, d, c = s2.geometry, s2.vertices, s2.dimensions, s2.constraints
s2.setPrimaryObject(option=SUPERIMPOSE)
p.projectReferencesOntoSketch(sketch=s2, upToFeature=p.features['Wire-1'], 
    filter=COPLANAR_EDGES)
s2.Line(point1=(80.0, 0.0), point2=(43.55, 0.0))
s2.HorizontalConstraint(entity=g[3], addUndoState=False)
s2.copyMirror(mirrorLine=g[3], objectList=(g[2], ))
session.viewports['Viewport: 1'].view.setValues(nearPlane=540.356, 
    farPlane=853.639, width=72.9962, height=39.4027, cameraPosition=(123.244, 
    0.598606, 846.998), cameraTarget=(123.244, 0.598606, 150))
session.viewports['Viewport: 1'].view.setValues(cameraPosition=(143.719, 
    -0.803785, 846.998), cameraTarget=(143.719, -0.803785, 150))
s2.delete(objectList=(g[3], ))
session.viewports['Viewport: 1'].view.setValues(nearPlane=528.68, 
    farPlane=865.316, width=209.633, height=113.158, cameraPosition=(149.425, 
    10.2181, 846.998), cameraTarget=(149.425, 10.2181, 150))
session.viewports['Viewport: 1'].view.fitView()
s2.delete(objectList=(g[2], ))
s2.delete(objectList=(g[4], ))
s2.EllipseByCenterPerimeter(center=(-17.42, 0.0), axisPoint1=(34.84, 0.0), 
    axisPoint2=(23.74365234375, -3.26403045654297))
session.viewports['Viewport: 1'].view.setValues(nearPlane=541.23, 
    farPlane=852.765, width=63.3938, height=34.2194, cameraPosition=(66.823, 
    -0.397143, 846.998), cameraTarget=(66.823, -0.397143, 150))
s2.EllipseByCenterPerimeter(center=(-17.42, 0.0), axisPoint1=(
    -10.5273895263672, -0.0239110887050629), axisPoint2=(-17.42, 
    -3.26403045654251))
s2.autoTrimCurve(curve1=g[5], point1=(-21.6360321044922, -3.24548578262329))
s2.undo()
s2.Line(point1=(-17.42, 0.0), point2=(-17.42, 3.26403045660118))
s2.VerticalConstraint(entity=g[9], addUndoState=False)
s2.CoincidentConstraint(entity1=v[10], entity2=g[5], addUndoState=False)
s2.Line(point1=(-17.42, 3.26403045660118), point2=(-17.42, 0.0))
s2.VerticalConstraint(entity=g[10], addUndoState=False)
s2.ParallelConstraint(entity1=g[9], entity2=g[10], addUndoState=False)
s2.Line(point1=(-17.4359432082731, -3.26403030465029), point2=(-17.42, 0.0))
s2.autoTrimCurve(curve1=g[5], point1=(-26.150146484375, -3.44192457199097))
s2.delete(objectList=(g[11], ))
s2.delete(objectList=(c[34], ))
s2.delete(objectList=(g[9], ))
s2.delete(objectList=(g[10], ))
s2.undo()
s2.undo()
s2.undo()
s2.undo()
s2.autoTrimCurve(curve1=g[7], point1=(-11.3124542236328, -1.63469851016998))
s2.autoTrimCurve(curve1=g[14], point1=(-10.7629089355469, 0.918988585472107))
s2.delete(objectList=(c[34], ))
s2.delete(objectList=(g[9], ))
s2.unsetPrimaryObject()
p = mdb.models['Model-1'].parts['root']
s = p.features['Wire-1'].sketch
mdb.models['Model-1'].ConstrainedSketch(name='__edit__', objectToCopy=s)
s1 = mdb.models['Model-1'].sketches['__edit__']
g, v, d, c = s1.geometry, s1.vertices, s1.dimensions, s1.constraints
s1.setPrimaryObject(option=SUPERIMPOSE)
p.projectReferencesOntoSketch(sketch=s1, upToFeature=p.features['Wire-1'], 
    filter=COPLANAR_EDGES)
s1.delete(objectList=(g[2], ))
