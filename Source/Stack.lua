stack = {};
stack.__index = stack;

--Constructor method that will return the stack class. Runtime of O(1)
function stack.new(size)
	local self = setmetatable({}, stack)
	self.stack = {};
	self.stackSize = size;
	self.top = -1;
	return self
end

--Push method that will add an element onto the stack. (LIFO) Runtime of O(1)
function stack:push(element)
	if (#self.stack == self.stacksize) then
		return "Stack Overflow";
	end
	self.top += 1;
	self.stack[self.top] = element;
end

--Pop method that will pop the top element off the stack Runtime of O(1)
function stack:pop()
	if (self:isEmpty()) then
		return "Error: No elements";
	end
	local poppedItem = self.stack[self.top];
	self.stack[self.top] = nil;
	self.top -= 1;
	return poppedItem;
end

--Peek method that will return the element at the top of the stack. Runtime of O(1)
function stack:peek()
	if (self:isEmpty()) then
		return "No elements";
	end
	return self.stack[self.top];
end

--IsEmpty method that checks to see if the stack is empty. Runtime of O(1)
function stack:isEmpty()
	return self.top == -1;
end

return stack;










