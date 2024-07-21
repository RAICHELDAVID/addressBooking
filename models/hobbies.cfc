component persistent="true" table="person_hobbies" {
    property name="id" fieldtype="id";
    property name="personid" fieldtype="many-to-one" cfc="person" fkcolumn="personid";
    property name="hid" cfc="hobbytable" fkcolumn="hid";

}

