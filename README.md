GeoTV
=====

Adds several geographic template variable types to MODX Revolution. They allow
multiple geographic points and/or areas to be associated with a resource and can
render the location data as a series of GPS co-ordinates.

Mapping data is provided by the [Google Maps Javascript API][1].

Installation
------------

Install via the MODX package manager.

Use
---

GeoTV provides two new TV types, Geographic Area and Geographic Point.

Once a TV has been created, add it to a template. The template variables tab
of a resource using the template will contain a map centered at the location
specified in the TV input options. New locations can be created with the draw
tool icon on the top of the map. It can be panned using the "hand" icon. You can
clear the geo data by clicking the "Clear all locations" link.

### Geographic Area

TV data is stored as a number of "areas" representing a fenced geographic
region.

When creating a new template variable, select 'Geographic Area' as the input
type. You can specify the default map center and zoom level. This is only used
when editing resources in the manager. Latitude and longitude co-ordinates
should be specified in decimal degrees format. Zoom level can be any number from
1 to 30. Many areas of the world do not have map data above zoom level 20.

Next, select 'Geographic Area' as the output type. There are several fields that
allow you to customize the output.

  * Wrapper template: the name of a chunk used to render the entire set of
    geographic data. The [[+areas]] placeholder will contain all of the rendered
    areas.
  * Area template: the name of a chunk used to render each individual fenced
    area. The [[+points]] placeholder contains the rendered points for the
    polygon.
  * Area separator: A string used to separate each area. The text will be
    inserted between each area in the rendered output.
  * Point template: the name of a chunk used to render each set of geographic
    co-ordinates. The [[+latitude]] and [[+longitude]] placeholders contain the
    latitude and longitude co-ordinates respectively.
  * Point separator: A string used to separate each point. The text will be
    inserted between each set of co-ordinates in the rendered output.

### Geographic Point

TV data is stored as a number of latitude/longitude co-ordinate pairs.

When creating a new template variable, select 'Geographic Point' as the input
type. You can specify the default map center and zoom level. This is only used
when editing resources in the manager. Latitude and longitude co-ordinates
should be specified in decimal degrees format. Zoom level can be any number from
1 to 30.

Next, select 'Geographic Point' as the output type. There are several fields
that allow you to customize the output.

  * Wrapper template: the name of a chunk used to render the entire set of
    geographic data. The [[+points]] placeholder will contain all of the rendered
    areas.
  * Point template: the name of a chunk used to render each set of geographic
    co-ordinates. The [[+latitude]] and [[+longitude]] placeholders contain the
    latitude and longitude co-ordinates respectively.
  * Point separator: A string used to separate each point. The text will be
    inserted between each set of co-ordinates in the rendered output.

Contributing
------------

GeoTV is [hosted on GitHub][2]. Ideas for improvements? Bug reports? Please open
an issue in the project's issue queue.


[1]: https://developers.google.com/maps/documentation/javascript/
[2]: https://github.com/osucomm/geotv
