component persistent="true" table="hobbies" {
    property name="hobby" fieldtype="id";
    property name="person" fieldtype="many-to-one" cfc="person" fkcolumn="personid";

}
