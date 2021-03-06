
import java.util.HashMap;

import be.test.vcs.Validator;

import be.test.vcs.CvsValidator;
import be.test.vcs.DssValidator;
import be.test.vcs.Project;
import be.test.vcs.VcsService;

/**
 * @author giannigiglio
 *
 */
public class VcsValidator implements Validator {

	private VcsService vcsService;
	private CvsValidator cvsValidator;
	private DssValidator dssValidator;

	public VcsValidator() {
	}
	
	private void doSanityCheck(String url, String check){
		//check witch type must be validated
		cvsValidator.validate(url,check);
		dssValidator.validate(url, check);
		
	}

	public void validate(String value, String check, long projectId, Project project, HashMap<String, Object> context) {
		doSanityCheck(value,check);
		vcsService.getVcsUrlStatus(value);
	}

	public VcsService getVcsService() {
		return vcsService;
	}

	public void setVcsService(VcsService vcsService) {
		this.vcsService = vcsService;
	}

}

