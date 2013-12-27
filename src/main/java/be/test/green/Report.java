package be.test.green;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.UUID;

import org.joda.time.DateTime;

public class Report {

	private List<State> state;
	private UUID uuid;
	private String name;
	private DateTime dateTime;
	private Map<String, String> statistics;
	private List<State> states;

	public Report() {
		state = new ArrayList<State>();
	}

	public List<State> getState() {
		return state;
	}

	public void setState(List<State> state) {
		this.state = state;
	}

	public UUID getUuid() {
		return uuid;
	}

	public void setUuid(UUID uuid) {
		this.uuid = uuid;
	}

	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
	}

	public DateTime getDateTime() {
		return dateTime;
	}

	public void setDateTime(DateTime dateTime) {
		this.dateTime = dateTime;
	}

	public Map<String, String> getStatistics() {
		return statistics;
	}

	public void setStatistics(Map<String, String> statistics) {
		this.statistics = statistics;
	}

	public List<State> getStates() {
		return states;
	}

	public void setStates(List<State> states) {
		this.states = states;
	}
	
	

}
