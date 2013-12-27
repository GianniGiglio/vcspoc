package be.test.vcs;


public interface VcsService {

	VcsUrlStatus getVcsUrlStatus(String url);

	String getLatestRevision(String url);

}
