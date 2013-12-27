package be.test.green;

public interface VcsValidationRules {

	void validateRequiredRevision(String value);

	void verifyUrlExistsAndAccessible(String value);

	String calculateFromScript(String fileUrl);

	void checkUrl(String value, String check);
	
	void validate(String url, String check);
	
}
