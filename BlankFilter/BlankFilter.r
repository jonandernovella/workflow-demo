AdvancedBlankFilter <- function(blanks, samples, cutoff) {
  blanks[is.na(blanks)] <- 0
  samples[is.na(samples)] <- 0
      
  blanks <- apply(blanks,1,median,na.rm=TRUE)
  samples <- apply(samples,1,max,na.rm=TRUE)
	    
  to.remove <- which(blanks/samples >= cutoff)
  return(to.remove)
  }

######################
#
#   Grep name in x
#
#####################
specgrep <- function(x,name) {
  x=x[,grep(name, names(x))]
    return(x)
    }

######################
#
#   Remove name in x
#
#####################
removegrep <- function(x,name) {
  x=x[,-grep(name, names(x))]
  return(x)
  }

args <- commandArgs(trailingOnly = TRUE)

input = args[1]
output = args[2]
samples<-read.table(input,sep='\t',header=T)

# separate blanks
Blanks=specgrep(samples,"BLANK")
samples=removegrep(samples,"BLANK")

to.remove<-AdvancedBlankFilter(Blanks,samples,0.01)
cat("Number of filtered features: ", length(to.remove), "\n")
samples=samples[-to.remove,]

write.table(samples,file=output,sep='\t',row.names=F)
