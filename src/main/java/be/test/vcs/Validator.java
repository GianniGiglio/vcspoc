package be.test.vcs;

import java.util.HashMap;

public interface Validator {
	
	 void validate(String value, String check, long projectId, Project project, HashMap<String, Object> context);

}
