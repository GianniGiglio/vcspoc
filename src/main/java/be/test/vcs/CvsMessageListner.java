package be.test.vcs;

public class CvsMessageListner {
	
	private CacheService cacheService;
	private CvsUrlChecker cvsUrlChecker;
	
	private boolean validateCsvUrl(String url){
		return cvsUrlChecker.checkUrl(url);
		
	}

}
