import java.io.Serializable;

/**
 * Created by root on 6/15/16.
 */


public class MyPerson   implements Serializable{
	String name;
	Integer age;
	String gender;

	public MyPerson() {
		this.name = "aaa";
		this.age = 10;
		this.gender = "man";
	}

	public MyPerson(String name, Integer age, String gender) {
		System.out.println("arg constructor");
		this.name = name;
		this.age = age;
		this.gender = gender;
	}
}
