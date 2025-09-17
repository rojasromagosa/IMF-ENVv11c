*   Set of Manufacture Activities in GTAP database

cmt   "Bovine cattle, sheep and goat, horse meat products"
omt   "Meat products n.e.s."
vol   "Vegetable oils and fats"
mil   "Dairy products"
pcr   "Processed rice"
sgr   "Sugar"
ofd   "Food products n.e.s."
b_t   "Beverages and tobacco products"

tex   "Textiles"
wap   "Wearing apparel"
lea   "Leather products"

lum   "Wood products"    !! Lumber: wood and products of wood and cork, except furniture; articles of straw and plaiting materials
ppp   "Paper products, publishing" !! Note in GTAP 10 Publishing has been moved to "Information and communication"
nmm   "Mineral products n.e.s."
fmp   "Metal products"
mvh   "Motor vehicles and parts"
otn   "Transport equipment n.e.s."
ele   "Electronic equipment"           !! Electronic Equipment: office, accounting and computing machinery, radio, television and communication equipment and apparatus

$ifThen.gtap10 NOT %GTAP_ver%=="92" !! GTAP version 10 and above

    ome   "Machinery and equipment n.e.s." !! Machinery and equipment n.e.s.: electrical machinery and apparatus n.e.c., medical, precision and optical instruments, watches and clocks
    eeq   "Electrical equipment"           !! Manufacture of electrical equipment (includes manufacture of battery and Manufacture of electric motors)

    %chm%   "Chemical products"           !! from old crp sector: Manufacture of chemicals and chemical products (e.g Manufacture of basic chemicals, fertilizers and nitrogen compounds, plastics and synthetic rubber in primary forms)
    bph   "Basic pharmaceuticals"       !! from old crp sector: Manufacture of pharmaceuticals, medicinal chemical and botanical products
    rpp   "Rubber and plastic products" !! from old crp sector: Manufacture of rubber and plastics products (includes manufacture of plastic articles for the packing of goods)

$else.gtap10

    ome   "Machinery and equipment n.e.s." !! Machinery and equipment n.e.s.: electrical machinery and apparatus n.e.c., medical, precision and optical instruments, watches and clocks
    %chm%   "Chemical products (including rubber and plastic products)"

$endif.gtap10

omf   "Manufactures n.e.s."  !! Other Manufacturing: includes repair and installation of machinery and equipment, in GTAP < 10 it also includes recycling
i_s   "Iron and steel"
nfm   "Non-ferrous Metals"   !! Metals n.e.s. : production and casting of copper, aluminium, zinc, lead, gold, and silver
