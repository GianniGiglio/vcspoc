import be.test.vcs.VcsService;
import be.test.vcs.CacheDaoImpl;
import be.test.vcs.CacheDao;
import be.test.vcs.VcsUrlStatus;

public class VcsServiceImpl implements VcsService {

	private CacheDao cacheDao;

	public CacheDao getCacheDao() {
		return this.cacheDao;
	}

	public void setICacheDao(CacheDao cacheDao) {
		this.cacheDao = cacheDao;
	}

	public VcsUrlStatus getVcsUrlStatus(String url) {
		// TODO Auto-generated method stub
		return null;
	}

	public String getLatestRevision(String url) {
		// TODO Auto-generated method stub
		return null;
	}

}
