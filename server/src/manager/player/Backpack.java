package manager.player;

import java.util.ArrayList;
import java.util.Collection;
import com.google.gson.Gson;
import io.netty.channel.ChannelHandlerContext;

class Cell{
	public int		cell_idx;
	public int		item_id;
	public int		item_num;
	
	Cell(){
		cell_idx = 0;
		item_id = 0;
		item_num = 0;
	}
	
	Cell(int idx, int id, int num){
		cell_idx = idx;
		item_id = id;
		item_num = num;
	}
}

public class Backpack {
	public int 				  cell_number=15;
	public ArrayList<Cell> 	  cells = new ArrayList<Cell>();
	
	public Backpack() {
	}
	
	public void sendBackpackInfo(ChannelHandlerContext ctx){	
		protocol.backpack_num bp_num = new protocol.backpack_num();
		bp_num.num = cell_number;
		ctx.write( bp_num.data());
		
		System.out.println(String.format("cells:%d", cells.size()));
		
		for(Cell cell : cells) {
			sendCellInfo( ctx, cell);
		}
	}
	
	public void sendCellInfo(ChannelHandlerContext ctx, Cell cell) {
		protocol.backpack_cell bp_cell = new protocol.backpack_cell();
		bp_cell.index = cell.cell_idx;
		bp_cell.item_id = cell.item_id;
		bp_cell.item_num = cell.item_num;
		ctx.write(bp_cell.data());
	}
	
	public Cell AddItem(int item_id, int count, int type){
		Cell cell = getCellByItemID(item_id);
		if( cell!=null){
			cell.item_num += count;
		}else
		{
			int fristCellEmpty = getFirstEmptyCell();
			if( fristCellEmpty!=-1) {
				cell = new Cell(fristCellEmpty, item_id, count);
				cells.add(cell);
			}
		}
		
		return cell;
	}
	
	public Cell useItem( int cellIdx, ChannelHandlerContext ctx) {
		Cell cell = getCellByItemIdx(cellIdx);
		if( cell!=null && cell.item_num>0){
			cell.item_num -= 1;
		}
		
		if(cell!=null) {
			sendCellInfo(ctx, cell);
			
			if(cell.item_num==0) {
				cells.remove(cell);
			}
			
			return cell;
		}
		
		return null;
	}
	
	public void collectItem(int item_id, int count, int type, ChannelHandlerContext ctx) {
		Cell cell = AddItem(item_id, count, type);
		
		// send to client
		if(cell!=null) {
			sendCellInfo(ctx, cell);
		}else
		{
			System.out.println("there are no space for new item. client shout respect for this");
		}
	}
	
	public Cell getCellByItemID(int id) {
		for(Cell cell : cells) {
			if(cell.item_id == id) {
				return cell;
			}
		}
		
		return null;
	}
	
	public Cell getCellByItemIdx(int idx) {
		for(Cell cell : cells) {
			if(cell.cell_idx == idx) {
				return cell;
			}
		}
		
		return null;
	}
	
	public int getFirstEmptyCell() {
		int cellIdx = -1;
		for(int i=0; i<cell_number; i++) {
			if(isCellEmpty(i)) {
				cellIdx = i;
				break;
			}
		}
		
		return cellIdx;
	}
	
	public boolean isCellEmpty(int idx) {
		for(Cell cell : cells) {
			if(cell.cell_idx == idx) {
				return false;
			}
		}
		
		return true;
	}
}
