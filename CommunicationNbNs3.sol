pragma solidity ^0.4.20;

contract WorkbenchBase {
    event WorkbenchContractCreated(string applicationName, string workflowName, address originatingAddress);
    event WorkbenchContractUpdated(string applicationName, string workflowName, string action, address originatingAddress);

    string internal ApplicationName;
    string internal WorkflowName;

    function WorkbenchBase(string applicationName, string workflowName) internal {
        ApplicationName = applicationName;
        WorkflowName = workflowName;
    }

    function ContractCreated() internal {
        WorkbenchContractCreated(ApplicationName, WorkflowName, msg.sender);
    }

    function ContractUpdated(string action) internal {
        WorkbenchContractUpdated(ApplicationName, WorkflowName, action, msg.sender);
    }
}

contract CommunicationNbNs3 is WorkbenchBase('CommunicationNbNs3', 'CommunicationNbNs3') {
	//Set of States
    enum StateType { Request, Respond}

    //List of properties
    StateType public  State;
    address public  BaseNode;
    address public  ServiceNode;
    address public  Observer;

    int public ResponseMessage;
	
	// constructor function
    function CommunicationNbNs3(address Observer) public
    {
        BaseNode = msg.sender;
        Observer = Observer;
        State = StateType.Request;

        ContractCreated();
    }

	// call this function to send a request
    function SendRequest() public
    {
        if (BaseNode != msg.sender)
        {
            revert();
        }

        State = StateType.Request;

        ContractUpdated('SendRequest');
    }

    // call this function to send a response
    function SendResponse(int responseMessage) public
    {
        ServiceNode = msg.sender;
        if (ServiceNode != msg.sender)
        {
            revert();
        }
        

        // call ContractUpdated() to record this action
        ResponseMessage = responseMessage;
        State = StateType.Respond;
        ContractUpdated('SendResponse');
    }
}