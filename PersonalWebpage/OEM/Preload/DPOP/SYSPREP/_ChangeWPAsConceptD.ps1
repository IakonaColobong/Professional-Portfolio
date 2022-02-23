
$XMLPath = $args[0]
[xml] $xdoc_Layout =  get-content  "$XMLPath" -Encoding UTF8

# Multiple NS example1
# [System.Xml.XmlNamespaceManager] $nsm = new-object System.Xml.XmlNamespaceManager $xdoc_Layout.NameTable
$nsm = New-Object System.Xml.XmlNamespaceManager($xdoc_Layout.NameTable)
$nsm.AddNamespace('ns','urn:schemas-microsoft-com:unattend')

$node = $xdoc_Layout.SelectSingleNode("//ns:settings[@pass='specialize']/ns:component[@name='Microsoft-Windows-Shell-Setup']/ns:Themes/ns:DesktopBackground", $nsm)
$node.'#text' = '%WINDIR%\web\wallpaper\ConceptD.jpg'
$xdoc_Layout.save("$XMLPath")