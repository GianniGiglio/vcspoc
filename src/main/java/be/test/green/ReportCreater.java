/**
 * 
 */
package be.test.green;

import java.util.Map;

import org.joda.time.DateTime;

/**
 * @author giannigiglio
 *
 */
public abstract class ReportCreater {

	/**
	 * 
	 */
	public ReportCreater() {
		// TODO Auto-generated constructor stub
	}
	
	private Report createReport(InputType inputType){
		Report report =new Report(); 
		report.setName(getNameFromInput());
		return report;
		
	}
	
	public abstract String getNameFromInput();
	public abstract DateTime getDateTimeFromInput();
	public abstract Map<String,String> getStatisticsFromInput();

}
