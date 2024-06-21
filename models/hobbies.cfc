component persistent="true" table="person_hobbies" {
    property name="id" fieldtype="id";
    property name="hid" fieldtype="id";
    property name="person" fieldtype="many-to-one" cfc="person" fkcolumn="personid";

}
