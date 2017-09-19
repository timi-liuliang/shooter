package App;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;

import sun.misc.Signal;
import sun.misc.SignalHandler;

public class KillHandler implements SignalHandler {
	private static final Logger logger = LogManager.getLogger("KillHandler");

	public void registerSignal(String signalName) {
		Signal signal = new Signal(signalName);
		Signal.handle(signal, this);
	}
	
	@Override
	public void handle(Signal signal) {
		if( signal.getName().equals("TERM") ||		// (Kill -15)
			signal.getName().equals("USR1") || 		// (Kill -10)
			signal.getName().equals("USR2")) 		// (Kill -12)
		{
			logger.info("server close processing...");
			
			logger.info("save ranking data to db...");
			manager.ranking.RankingMgr.getInstance().saveToDB();
			
			logger.info("server close finished");
			System.exit(0);
		}
	}

}
