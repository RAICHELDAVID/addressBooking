component persistent="true" table="hobbies" {
    property name="hname" fieldtype="string";
    property name="hid" fieldtype="many-to-one" cfc="hobbies" fkcolumn="hid";

}
