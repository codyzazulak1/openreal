class AgentsController < ApplicationController

  before_action :authenticate_agent!
end
